# The ContentItem-class within this module can be used to make any model in
# your application to be 'blogabble'. Just derive from ContentItems::ContentItem
module ContentItem

  def self.included(base)
    base.extend ContentItem::ClassMethods
  end


  module_function
  # Render :txt as markdown with Redcarpet
  def markdown(txt)
    options = [
               :hard_wrap, :filter_html, :filter_styles, :autolink,
               :no_intraemphasis, :fenced_code, :gh_blockcode
              ]
    doc = Nokogiri::HTML(Redcarpet.new(txt, *options).to_html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.xpath('//body').to_s.gsub(/<\/?body>/,"").html_safe
  end
  
  # normalize tags 
  def normalized_tags_with_weight(resource)
    max_weight = resource.tags_with_weight.map{|t,w| w}.max{ |a,b| a.round <=> b.round }
    resource.tags_with_weight.map do |tag,weight|
      [tag, (8/max_weight*weight).round]
    end
  end
  
  # == ContentItem
  # Can be a 'Page', a 'Posting' or something else you want to be
  # * Commentable
  # * Rateable
  # * Able to display in RSS-feeds
  # * and more.
  #
  # Please note that you should use <code>stored_in :your_collection_name</code>
  # in your derived class. Otherwise Mongo will store all content_items in
  # one single collection named 'content_items_content_items' and properly this
  # will not what you will do. Though it may make sense in some cases.
  module ClassMethods
    def acts_as_content_item
      class_eval <<-EOV
        include Mongoid::Document
        include Mongoid::Timestamps
        include Mongoid::Taggable
        include CoverPicture

        # ContentItems should have an unique title
        field :title
        index :title
        validates_presence_of :title
        validates_uniqueness_of :title

        # ContentItems marked as 'draft' should not be in the default-scope
        field :is_draft, :type => Boolean, :default => true
        scope :drafts, lambda { unscoped.where(is_draft: true ) }

        if self.respond_to?(:is_template)
          scope :published, lambda { unscoped.where(is_draft: false, is_template: false ) }
        else
          scope :published, lambda { unscoped.where(is_draft: false ) }
        end

        # Will return a truncated version of the title if it exceeds the maximum
        # length of titles used in the menu (or wherever you can't display long titles)
        def short_title
          title.truncate(CONSTANTS['title_max_length'].to_i, :omission => '...')
        end

        # Display title with markers for templates and drafts
        def title_and_flags
          title_html = self.t(I18n.locale,:title)||self.title
          if self.respond_to?(:is_template)
            title_html += "&nbsp;<span class='templage_flag'>#{I18n.translate(:is_a_template_flag)}</span>".html_safe if self.is_template
          end
          title_html += "&nbsp;<span class='draft_flag'>#{I18n.translate(:is_a_draft_flag)}</span>".html_safe if self.is_draft
          title_html.html_safe
        end


        # A standard <code>link_to 'Name', @page</code> will put in a link
        # to "/pages/OPBJECT_ID" but we want to see the title in the link
        # (Google prefers that). See: PagesController::permalinked
        def link_to_title
          short_title_for_url.txt_to_url
        end

        def render_intro(interpret=true)
          content_for_intro(interpret)
        end

        def render_for_html(txt,context_view=nil)
          @context_view ||= context_view if context_view
          self.interpreter ||= :markdown
          case self.interpreter.to_sym
          when :markdown
            markdown(txt).html_safe
          when :textile
            RedCloth.new(txt).to_html
          when :simple_text
            txt.each_line.map do |line|
              '<p>' + line.strip + '</p>' unless line.strip.blank?
            end.compact.join("\n")
          else
            txt
          end.gsub( /ATTACHMENT:[([0-9])+]/ ) { |attachment|
            render_attachment(attachment.gsub( /ATTACHMENT:/,'' ).to_i)
          }.gsub( /COMPONENT:[([0-9])+]/ ) { |component|
            component_i = component.gsub( /\D/,'' ).to_i
            render_page_component(component_i)
          }.gsub(/YOUTUBE(_PLAYLIST)?:([a-z|A-Z|0-9|\\-|_])+/) { |tag|
            args = tag.split(':')
            case args[0]
            when 'YOUTUBE'
              embed_youtube_video(args[1])
            when 'YOUTUBE_PLAYLIST'
              embed_youtube_playlist(args[1])
            else
              "ARGUMENT ERROR: " + args.inspect
            end
          }.gsub(/PLUSONE/, '<g:plusone size="small"></g:plusone>')
          .gsub( /\\[LOCATION:([\\d\\., \\-]+)\\]/) {|location|
            render_location_link(location.gsub('LOCATION','').gsub('[','').gsub(']','').gsub(':',''))
          }
          .gsub(/\\[PLACE:([a-z|A-Z|0-9|\\-| |,]+)\\]/) {|place|
            render_place_link(place.gsub('PLACE','').gsub('[','').gsub(']','').gsub(':',''))
          }.html_safe
        end

        private
        def content_for_intro
          raise "ABSTRACT_METHOD_CALLED - Overwrite content_for_intro"
        end

        def render_attachment(idx)
          idx ||= 1
          idx -= 1
          if @context_view
            attachment = self.attachments.all[idx]
            if attachment
              if attachment.file_content_type =~ /image/
                @context_view.image_tag( @context_view.w3c_url(attachment.file.url(:medium)) )
              elsif attachment.file_content_type =~ /video/
                @context_view.video_tag(@context_view.w3c_url(attachment.file.url), :controls => true, :autoplay => false)
              else
                @context_view.link_to(attachment.file_file_name,@context_view.w3c_url(attachment.file.url))
              end
            else
              "ATTACHMENT "+idx.to_s+" NOT FOUND"
            end
         end
        end

        def render_component(idx)
          "RENDER COMPONENT NOT IMPLEMENTED FOR #{self.class.to_s}"
        end

        def embed_youtube_playlist(youtube_tag)
          "<iframe width='560' height='345' src='http://www.youtube.com/p/" +
            youtube_tag +
          "?version=3&amp;hl=en_US' frameborder='0' allowfullscreen=''></iframe>"
        end

        def embed_youtube_video(youtube_tag)
          "<iframe width='420' height='345' src='http://www.youtube.com/embed/"+
            youtube_tag +
            "' frameborder='0' allowfullscreen=''></iframe>"
        end
        
        def render_location_link(location)
          "<a href='#' class='open-location'>"+location+"</a>"
        end

        def render_place_link(place)
          "<a href='#' class='open-place'>"+place+"</a>"
        end
      EOV
    end
  end


end
