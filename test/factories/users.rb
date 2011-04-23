Factory.define :user do |u|
   u.email      'user@domain.com'
   u.name       'user'
   u.roles_mask 1
   u.password   "secret"
   u.password_confirmation "secret"
end

Factory.define :admin, :class => User do |u|
  u.email 'admin@yourdomain.com'
  u.name  'Administrator'
  u.roles_mask  5
  u.password   "secret"
  u.password_confirmation "secret"
end
