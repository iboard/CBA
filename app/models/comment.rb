# Comment is a polymorphic class. Any 'commentable' can have comments.
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field  :name
  field  :email
  field  :comment

  validates             :email, :presence => true, :email => true
  validates_presence_of :name
  validates_presence_of :comment
  
  embedded_in :commentable, :inverse_of => :comments
  
  scope :since, lambda { |since| where(:created_at.gt => since) } 

end