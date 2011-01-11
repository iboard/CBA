#
# Load configuration from
# config/application.yml and config/user_db.yml
#

if File::exists?("#{Rails.root}/config/user_db.yml")
  USER_DATABASE=YAML.load_file("#{Rails.root}/config/user_db.yml")[Rails.env]
else
  USER_DATABASE={ 'use_remote_database' => false }
end

APPLICATION_CONFIG=YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]['application']
CONSTANTS=YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]['constants']