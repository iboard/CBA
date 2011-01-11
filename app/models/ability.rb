class Ability

  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user

    if user.role? :admin
      can :manage, :all  # Admin is god
    else
      # Not Admin
      unless user.new_record?
        # Any signed in user
        can :read, User
        can [:manage, :update_avatar, :crop_avatar], User do |usr|
          user == usr
        end
        
        for role in user.roles
          # Users with roles 
          case role
          when 'confirmed_user'
            can :read, User
          when 'moderator'
          when 'author'
          when 'maintainer'
          else
            raise Exception.new("Unknown role '#{role}' in #{__FILE__}:#{__LINE__}")
          end
        end
      else
        # Guest
        
      end
    end
  end
  
end