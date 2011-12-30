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
               :hard_wrap, :filter_styles, :autolink,
               :no_intraemphasis, :fenced_code, :gh_blockcode
              ]
    doc = Nokogiri::HTML(Redcarpet.new(txt, *options).to_html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.xpath('//body').to_s.gsub(/<\/?body>/,"").html_safe
  end
  
  def textilize(txt)
    Textile::textilize(txt)
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

        # ContentItem should not be visible before publish_at
        field :publish_at, type: Time

        # ContentItem should not be visible by expire_at
        field :expire_at, type: Time
  
        # ContentItems marked as 'draft' should not be in the default-scope
        field :is_draft, :type => Boolean, :default => true
        scope :drafts, -> { where(is_draft: true ) }

        if self.respond_to?(:is_template)
          scope :published, -> { where(is_draft: false, is_template: false) }
        else
          scope :published, -> { where(is_draft: false) }
        end

        scope :online, -> { any_of(
                 {:publish_at=>nil,:expire_at=>nil},
                 {:publish_at.lte=>Time.now(),:expire_at=>nil},
                 {:publish_at.lte=>Time.now(),:expire_at.gt=>Time.now()},
                 {:publish_at => nil, :expire_at.gt=>Time.now()}
                )}

        scope :expired,     -> { where(:expire_at.lte=>Time.now) }
        scope :pre_release, -> { where(:publish_at.gt => Time.now()) }

        def is_online?
          (self.publish_at.nil? || self.publish_at <= Time.now()) &&
          (self.expire_at.nil? || self.expire_at > Time.now())
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

        def intro
          content_for_intro
        end

        def publish_at_date
          publish_at.strftime("%Y-%m-%d") if publish_at
        end

        def publish_at_date=(new_date)
          unless new_date.nil? || new_date.blank?
            y,m,d = new_date.split(/\\-|\\.|:|\\//)
            self.publish_at = Time.new(y.to_i,m.to_i,d.to_i)
          else
            self.publish_at = nil
          end
        end

        def publish_at_time
          self.publish_at.strftime("%H.%M") if self.publish_at
        end
        
        def publish_at_time=(_new_time)
          unless self.publish_at.nil? || _new_time.nil? || _new_time.blank?
            h, m = _new_time.split(/[\\:|\\.| ]/)
            self.publish_at = self.publish_at.change(:hour => h.to_i, :min => m.to_i)
          end
        end

        def expire_at_date
          expire_at.strftime("%Y-%m-%d") if expire_at
        end

        def expire_at_date=(new_date)
          unless new_date.nil? || new_date.blank?
            y,m,d = new_date.split(/\\-|\\.|:|\\//)
            self.expire_at = Time.new(y.to_i,m.to_i,d.to_i)
          else
            self.expire_at = nil
          end
        end

        def expire_at_time
          self.expire_at.strftime("%H.%M") if self.expire_at
        end
        
        def expire_at_time=(_new_time)
          unless self.expire_at.nil? || _new_time.nil? || _new_time.blank?
            h, m = _new_time.split(/[\\:|\\.| ]/)
            self.expire_at = self.expire_at.change(:hour => h.to_i, :min => m.to_i)
          end
        end
        
        private
        def content_for_intro
          raise "ABSTRACT_METHOD_CALLED - Overwrite content_for_intro"
        end
      EOV
    end
  end


end
