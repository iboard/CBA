# -*- encoding : utf-8 -*-

# = SiteMenu
#
# is a Mongoid::Tree of menu-entries
#
# == Fields:
#   name:
#     [String] The Label of the menu-item
#   target:
#     [String] The URL to call on click
#   position:
#     [Integer] The position in menus. (default order)
#   role_needed:
#     [Integer] The user (at least) must have this role.
class SiteMenu
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  field :name, :type => String
  validates_presence_of :name
  field :target, :type => String
  field :position, :type => Integer, :default => 999999
  field :role_needed, :type => Integer
  field :info, :type => String

  default_scope order_by(:position => :asc)

  def current_child?(view_context)
    return true if view_context.current_page?(self.target)
    self.children.each do |child|
      return true if child.current_child?(view_context)
    end
    false
  end

  def has_child_path?(path)
    child = nil
    self.traverse do |t|
      if t.target == path
        child = t
        break
      end
    end
    !child.nil?
  end
end
