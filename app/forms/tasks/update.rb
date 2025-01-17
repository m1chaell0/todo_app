class Tasks::Update < ActiveType::Record[Task]
  validate :user_can_edit_task
  validate :scheduled_for_must_be_in_the_future

  def user_can_edit_task
    errors.add(:base, "You cannot edit this task") if user_id_changed?
  end

  def scheduled_for_must_be_in_the_future
    errors.add(:scheduled_for, "must be in the future") if scheduled_for < Time.current
  end
end
