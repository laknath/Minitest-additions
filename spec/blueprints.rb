require 'machinist/active_record'
require 'sham'
require 'faker'

#Sham.name           { Faker::Name.name }

User.blueprint do
  #email                 { Sham.email }
end
