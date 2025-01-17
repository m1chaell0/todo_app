class Tasks::Destroy < ActiveType::Object[Task]
  attribute :current_user

  before_destroy :ensure_task_can_be_deleted, prepend: true do
    throw(:abort) if errors.any?
  end

  def ensure_task_can_be_deleted
    errors.add(:base, "You cannot delete this task") unless user_id == current_user.id
  end
end
