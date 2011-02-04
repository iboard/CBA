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

  # Calculate the time left a user can edit a comment
  def time_left_to_edit
    @time_left_to_edit ||= CONSTANTS['max_time_to_edit_new_comments'].to_i - ( (Time.now()-self.updated_at )/1.minute ).to_i
  end


end