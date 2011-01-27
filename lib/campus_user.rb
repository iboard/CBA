#
# This Library is not active !!!! do not push to repository
#
module CampusUser  

  def self.load_cache_file  
    UserCache.new(File.new("#{Rails.root}/tmp/cache/campus_users.xml").read)
  end
    
  class CampusUser < Struct.new(
           :campus_id,:username,:crypted_password,
           :keywords, :email,   :timezone,
           :prefered_language)
  end
  
  class UserCache
    attr_reader :users
    
    def initialize(data)
      @document = REXML::Document.new(data)
      @users    = @document.elements.first.elements.map { |u|
        CampusUser.new( 
                        u.get_text('id'),
                        u.get_text('username'),
                        u.get_text('crypted-password'),
                        u.get_text('keywords'),
                        u.get_text('mail'),
                        u.get_text('timezone'),
                        u.get_text('prefered_language')
                      )
      }
    end
    
    def find_by_username(name)
      @users.select { |u|
        u.username == name
      }
    end
        
  end

end
