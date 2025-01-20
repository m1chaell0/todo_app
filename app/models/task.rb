# == Schema Information
#
# Table name: tasks
#
#  id            :integer          not null, primary key
#  title         :string           not null
#  description   :text
#  scheduled_for :datetime         not null
#  user_id       :integer          not null
#  category_id   :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_tasks_on_category_id  (category_id)
#  index_tasks_on_user_id      (user_id)
#

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :scheduled_for, presence: true

  scope :active, -> { where("scheduled_for > ?", Time.now) }
end
