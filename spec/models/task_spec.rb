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
    let(:task1) { create(:task, user: user, category: category, scheduled_for: Time.now - 1.day) }
    let(:task2) { create(:task, user: user, category: category, scheduled_for: Time.now + 1.day) }

    before do
      task1
      task2
    end

    describe ".active" do
      it "returns only future tasks" do
        expect(user.tasks).to match_array([ task1, task2 ])
        expect(user.tasks.active).not_to include(task1)
      end
    end
  end
end
