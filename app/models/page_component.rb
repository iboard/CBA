# -*- encoding : utf-8 -*-

# This is a Device-User-Class extended with ROLES, Avatar-handling, and more
class PageComponent
  include Mongoid::Document
  cache
  embedded_in :page
  embedded_in :article

  include Translator
  translate_fields [:title, :body]

  default_scope lambda { asc(:position) }

  field :position, :type => Integer, :default => 9999
  field :title,    :required => true, :default => '(unnamed)'
  field :body

  field :page_template_id, :type => BSON::ObjectId
  def page_template
    PageTemplate.criteria.for_ids(self.page_template_id).first || page.page_template
  end
  def page_template=(new_template)
    self.page_template_id = new_template.id if new_template
  end

  # TODO: Remove duplication!
  # TODO:   This code occurs in Page and PageComponent. Move it to a single
  # TODO:   place.
  def render_body(view_context=nil)
    @view_context = view_context
    rc = "\n<div class='page-component' id='page-component-#{self.id.to_s}'>\n"
    if self.page_template
      rc += self.page_template.render do |template|
        (template||"TITLE BUTTONS BODY COMPONENTS ATTACHMENTS COMMENTS")\
                .gsub(/TITLE/, self.t(I18n.locale,:title))\
                .gsub(/BODY/,  self.page ? self.page.render_for_html(self.t(I18n.locale,:body)||'') : 'BODY NO PAGE')\
                .gsub(/COVERPICTURE/, self.page ? self.page.render_cover_picture : 'PICT NO PAGE')\
                .gsub(/COMPONENTS/, '')\
                .gsub(/COMMENTS/, self.page.render_comments)\
                .gsub(/COMPONENT\[(\d)+\]/) { |component_number|
                  "NESTED COMPONENTS NOT SUPPORTED YET" }\
                .gsub(/ATTACHMENT\[(\d+)\]/) { |attachment_number|
                  attachment_number.gsub! /\D/,''
                  idx = attachment_number.to_i - 1
                  if c = self.page.attachments[idx]
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
      rc += self.page.render_for_html(self.t(I18n.locale,:body)||'')
    end

    rc += case self.page.interpreter.to_sym
    when :markdown
      "\n[Edit](/pages/#{self.page.to_param}/page_components/#{self.to_param}/edit)\n"
    when :textile
      "\n\"Edit\":/pages/#{self.page.to_param}/page_components/#{self.to_param}/edit\n"
    else
      if @view_context
        "<p>"+@view_context.link_to(I18n.translate(:edit), @view_context.edit_page_page_component_path(self.page,self), :remote => true)+"</p>"
      else
        "<p>"+
          "<a href='/pages/#{self.page.to_param}/page_components/#{self.to_param}/edit' data-remote='true', title='Edit'>Edit</a>"+
        "</p>"
      end
    end
    rc += "\n</div>\n"
  end


  # Ask our page if removing of components is allowed
  alias_method :__original__delete, :delete
  def delete(options={})
    if self.page.is_template || self.page.allow_removing_component == true
      __original__delete(options)
    else
      self.errors.add('base', "Removing components is not allowed")
      false
    end
  end

end
