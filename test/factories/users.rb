Factory.define :user do |u|
   u.email      'user@domain.com'
   u.name       'user'
   u.roles_mask 1
   u.password   "secret"
   u.password_confirmation "secret"
end

  