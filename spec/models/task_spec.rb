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

require 'rails_helper'

describe Task, type: :model do
  describe "Associations" do
    context "belongs_to associations" do
      it { should belong_to(:category) }
      it { should belong_to(:user) }
    end
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
  end

  describe "Scopes" do
    let(:user) { create(:user, :with_email_address, :with_valid_password) }
    let(:category) { create(:category, user: user) }
    let(:task1) { create(:task, :completed, user: user, category: category) }
    let(:task2) { create(:task, :pending, user: user, category: category) }
    let(:task3) { create(:task, :overdue, user: user, category: category) }
    let(:task4) { create(:task, :in_progress, user: user, category: category) }

    before do
      task1
      task2
      task3
      task4
    end

    describe ".active" do
      it "returns not yet completed tasks" do
        expect(user.tasks.active).to match_array([ task2, task4 ])
        expect(user.tasks.active).not_to include(task1)
      end
    end

    describe ".completed" do
      it "returns only completed tasks" do
        expect(user.tasks.completed).to eq([ task1 ])
        expect(user.tasks.completed).not_to include(task3, task2, task4)
      end
    end

    describe ".pending" do
      it "returns only pending tasks" do
        expect(user.tasks.pending).to eq([ task2 ])
        expect(user.tasks.pending).not_to include(task1, task3, task4)
      end
    end
  end
end
