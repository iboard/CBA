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
          _markdown = case self.interpreter.to_sym
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
          end
          
          _interpreter = Interpreter.new(self,@context_view)
          _interpreter.render(_markdown)
        end

        private
        def content_for_intro
          raise "ABSTRACT_METHOD_CALLED - Overwrite content_for_intro"
        end
      EOV
    end
  end


end
