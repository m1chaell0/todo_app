FactoryBot.define do
  factory :task do
    title { Faker::Lorem.word }
    # description { Faker::Lorem.sentence }
    # scheduled_for { Time.now + 1.day }
    # category
  end
end
