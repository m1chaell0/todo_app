module Tasks
  class Update < ActiveType::Record[Task]
    validate :user_can_edit_task
    validate :end_time_must_be_in_the_future
    validate :start_time_changes_in_progress

    def user_can_edit_task
      errors.add(:base, "You cannot edit this task") if user_id_changed?
    end

    def end_time_must_be_in_the_future
      errors.add(:end_time, "must be in the future") if end_time && end_time < Time.current
    end

    def start_time_changes_in_progress
      return unless in_progress?
      if start_time_changed? && start_time_was > start_time
        errors.add(:start_time, "cannot be changed while task is in progress")
      end
    end
  end
end
