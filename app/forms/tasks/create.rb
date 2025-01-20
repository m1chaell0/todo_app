class Tasks::Create < ActiveType::Record[Task]
  validate :category_allowed
  validate :scheduled_for_must_be_in_the_future

  def category_allowed
    errors.add(:category_id, "is not accessible to you") unless category.user_id.in?([ user_id, nil ])
  end

  def scheduled_for_must_be_in_the_future
    errors.add(:scheduled_for, "must be in the future") if scheduled_for < Time.current
  end
end
