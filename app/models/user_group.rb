# -*- encoding : utf-8 -*-

class UserGroup
  include Mongoid::Document
  embedded_in  :user
  field        :name,    required: true
  validates_presence_of :name
  field        :members, type: Array, default: []
  # @return String comma-separated string of user-ids
  def member_tokens
    self.members.map{|id| id.to_s}.join(",")
  end
  
  # Split up string by comma and fetch User-ids into member-array
  # @param String comma-separated string of user-ids
  def member_tokens=(new_members)
    _ids = new_members.split(",").map { |id| id.strip }
    self.members = User.any_in( _id: _ids ).only(:_id).all.map{|i| i._id}
    @member_names = nil # clear chached variable
  end
  
  # @return String member names, comma-separated
  def member_names
    @member_names ||= User.any_in( _id: members).only(:name).map(&:name).join(", ")
  end
  
  def users
    User.any_in(_id: members)
  end
  
  # for autocomplete pre-data
  def id_and_name
    users.map {|friend|
      { id: friend.id.to_s, name: friend.name }
    }
  end
end
