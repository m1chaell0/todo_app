class RenameScheduledForToStartTime < ActiveRecord::Migration[8.0]
  def change
    rename_column :tasks, :scheduled_for, :start_time
  end
end
