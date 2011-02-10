# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#puts 'EMPTY THE MONGODB DATABASE'
#Mongoid.master.collections.reject { |c| c.name == 'system.indexes'}.each(&:drop)
user = User.create! :name => 'INITIALUSERNAME', :email => 'INITIALEMAIL', :password => 'cbaadmin', :password_confirmation => 'cbaadmin'
user.roles=['admin']
user.confirmed_at = Time.now()
user.save!
puts 'New user created: ' << user.name
puts "PLEASE CHANGE YOUR PASSWORD IMMEDIATELY! THE INITIAL PASSWORD IS cbaadmin"
