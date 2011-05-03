# This is a Device-User-Class extended with ROLES, Avatar-handling, and more
class PageComponent
  include Mongoid::Document
  cache
  embedded_in :page

  field :position, :default => 9999
  field :title,    :required => true, :default => '(unnamed)'
  field :body

  field :page_template_id, :type => BSON::ObjectId
  def page_template
    PageTemplate.criteria.for_ids(self.page_template_id).first || page.page_template
  end
  def page_template=(new_template)
    self.page_template_id = new_template.id if new_template
  end


  def render_body(view_context=nil)
    @view_context = view_context
    if self.page_template && @view_context
      self.page_template.render do |template|
        template.gsub(/TITLE/, self.title||'')\
                .gsub(/BODY/,  self.page ? self.page.render_for_html(self.body||'') : 'BODY NO PAGE')\
                .gsub(/COVERPICTURE/, self.page ? self.page.render_cover_picture : 'PICT NO PAGE')\
                .gsub(/COMPONENTS/, '')\
                .gsub(/COMMENTS/, self.page.render_comments)\
                .gsub(/COMPONENT\[(\d)+\]/) { |component_number|
                  "NESTED COMPONENTS NOT SUPPORTED YET" }\
                .gsub(/ATTACHMENT\[(\d+)\]/) { |attachment_number|
                  attachment_number.gsub! /\D/,''
                  idx = attachment_number.to_i - 1
                  c = self.page.attachments[idx]
                  if c
                    if c.file_content_type =~ /image/
                      @view_context.image_tag( c.file.url(:medium) )
                    else
                      @view_context.link_to( c.file_file_name, c.file.url )
                    end
                  else
                    "ATTACHMENT #{idx} NOT FOUND"
                  end
                }
      end
    else
      self.page.render_for_html(self.body)
    end
  end
end
