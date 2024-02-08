# frozen_string_literal: true

0.upto(100) do
  name = Faker::Name.name
  Client.create! name: name, email: Faker::Internet.email(name: name)
end
