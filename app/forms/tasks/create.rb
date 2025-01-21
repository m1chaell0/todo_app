class Tasks::Create < ActiveType::Record[Task]
  validate :category_allowed
  validate :start_end_time_must_be_in_the_future

  def category_allowed
    return if category.nil?
    errors.add(:category_id, "is not accessible to you") unless category.user_id.in?([ user_id, nil ])
  end

  def start_end_time_must_be_in_the_future
    errors.add(:start_time, "must be in the future") if start_time < Time.current
    errors.add(:end_time, "must be in the future") if end_time && end_time < Time.current
  end
end
