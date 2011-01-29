#
#  Define abilities for cancan
#
class Ability

  include CanCan::Ability
 
  # Called by cancan with the current_user or nil if
  # no user signed in. If so, we create a new user object which can be
  # identified as an anonymous user by calling new_record? on it.
  # if user.new_record? is true this means the session belongs to a not 
  # signed in user. 
  def initialize(user)
    user ||= User.new # guest user

    if user.role? :admin
      can :manage, :all  # Admin is god
    else
      # Not Admin
      unless user.new_record?
        # Any signed in user
        can [:read, :manage, :update_avatar, :crop_avatar], User do |usr|
          user == usr
        end
        for role in user.roles
          # Users with roles 
          case role
          when 'confirmed_user'
            can :read, [Page,Blog]
          when 'moderator'
            can :manage, Page
          when 'author'
            can :create, Page
            can :manage, Page do |page|
              page.user == user
            end
          when 'maintainer'
            can :manage, [Page,Blog]
          else
            raise Exception.new("Unknown role '#{role}' in #{__FILE__}:#{__LINE__}")
          end
        end
      end
      
      # Anybody
      can :read, [Page,Blog]
      can [:read, :create], Comment
      
    end
  end
  
end