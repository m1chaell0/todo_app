module Tasks
  class Complete < BaseService
    attr_reader :task, :current_user

    def initialize(task, current_user)
      @task = task
      @current_user = current_user
    end

    def call
      return fail!("You are not allowed to complete this task.") unless task.user_id == current_user.id
      return fail!("Task is already completed.") if task.completed?

      if task.update(completed_at: Time.current)
        success!("Task marked as completed.")
      else
        fail!("Failed to mark task as completed.")
      end
    end
  end
end
