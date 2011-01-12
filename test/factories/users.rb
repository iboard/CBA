# This will guess the User class
Factory.define :user do |u|
   u.id         "4d2c96042d194751eb000009"
   u.email      'admin@domain.com'
   u.name       'Administrator'
   u.roles_mask -1
   u.password   "secret"
   u.password_confirmation "secret"
end
