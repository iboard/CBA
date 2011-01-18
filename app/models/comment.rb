class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field  :name
  field  :email
  field  :comment

  validates             :email, :presence => true, :email => true
  validates_presence_of :name
  validates_presence_of :comment
  
  embedded_in :page, :inverse_of => :comments

end