#
# Load configuration from
# config/application.yml and config/user_db.yml
#
if File::exists?("#{Rails.root}/config/user_db.yml")
  USER_DATABASE=YAML.load_file("#{Rails.root}/config/user_db.yml")[Rails.env]
else
  USER_DATABASE={ 'use_remote_database' => false }
end

config_file =  File.expand_path('../../config/application.yml', __FILE__)
APPLICATION_CONFIG=YAML.load_file(config_file)[Rails.env]['application']
CONSTANTS=YAML.load_file(config_file)[Rails.env]['constants']
