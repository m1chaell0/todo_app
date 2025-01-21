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

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :start_time, presence: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :pending, -> { where(completed_at: nil).where("start_time > ?", Time.current) }
  scope :overdue, -> {
    where(completed_at: nil)
      .where("(end_time IS NOT NULL AND end_time < ?) OR (end_time IS NULL AND start_time < ?)", Time.current, Time.current)
  }
  scope :in_progress, -> {
    where(completed_at: nil)
      .where("start_time <= ?", Time.current)
      .where("end_time >= ?", Time.current)
  }

  # 'Active' tasks = not completed + not past end_time (if end_time is set).
  scope :active, -> {
    where(completed_at: nil)
      .where("end_time IS NULL OR end_time > ?", Time.current)
  }

  scope :by_status, ->(status) {
    case status
    when "completed"
      completed
    when "pending"
      pending
    when "overdue"
      overdue
    when "in_progress"
      in_progress
    else
      all
    end
  }

  def completed?
    completed_at.present?
  end

  def overdue?
    return false if completed?

    if end_time.present?
      Time.current > end_time
    else
      Time.current > start_time
    end
  end

  def pending?
    !completed? && Time.current < start_time
  end

  def in_progress?
    !completed? && !overdue? && !pending?
  end
end
