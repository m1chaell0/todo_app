# == Schema Information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text
#  start_time   :datetime         not null
#  user_id      :integer          not null
#  category_id  :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  end_time     :datetime
#  completed_at :datetime
#
# Indexes
#
#  index_tasks_on_category_id  (category_id)
#  index_tasks_on_user_id      (user_id)
#

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.word }
    # description { Faker::Lorem.sentence }
    # start_time { Time.now + 1.day }
    # category
  end

  trait :pending do
    start_time { 2.days.from_now }
    end_time { nil }
    completed_at { nil }
  end

  trait :overdue do
    start_time { 3.days.ago }
    end_time { 2.days.ago }
    completed_at { nil }
  end

  trait :completed do
    start_time { 3.days.ago }
    end_time { nil }
    completed_at { 1.day.ago }
  end

  trait :completed_overdue do
    start_time { 5.days.ago }
    end_time { 3.days.ago }
    completed_at { 2.days.ago } # after end_time, so it was overdue before being completed
  end

  trait :in_progress do
    start_time { 3.days.ago }
    end_time { 2.days.from_now }
    completed_at { nil }
  end
end
