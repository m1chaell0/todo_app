FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    # email_address { Faker::Internet.email }
  end

  trait :with_valid_password do
    password { "password" }
    password_confirmation { "password" }
  end

  trait :with_email_address do
    email_address { Faker::Internet.email }
  end
end
