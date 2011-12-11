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
  
  delegate :interpreter, :to => :page
  delegate :attachments, :to => :page
  delegate :cover_picture, :to => :page


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
