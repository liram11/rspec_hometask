# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name  }
    email { Faker::Internet.email(name: "#{first_name} #{last_name}")}
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    title { Faker::Superhero.prefix }
    role { Faker::Superhero.descriptor }

    verified { rand(0..1) }
    score { rand(0..100) }
  end
end
