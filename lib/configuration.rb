#
# Load configuration from
# config/application.yml and config/user_db.yml
#

# If you need to have the users been stored in a different place than
# the rest of your data, just define config/user_db.yml.
# **THIS DOESN'T WORK WITH CBA YET BUT WILL BE IMPLEMENTED IN FURTHER RELEASES**
if File::exists?("#{Rails.root}/config/user_db.yml")
  USER_DATABASE=YAML.load_file("#{Rails.root}/config/user_db.yml")[Rails.env]
else
  USER_DATABASE={ 'use_remote_database' => false }
end

config_file =  File.expand_path('../../config/application.yml', __FILE__)
APPLICATION_CONFIG=YAML.load_file(config_file)[Rails.env]['application']
CONSTANTS=YAML.load_file(config_file)[Rails.env]['constants']
