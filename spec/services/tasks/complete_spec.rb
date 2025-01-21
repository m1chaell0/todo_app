# spec/services/tasks/complete_spec.rb
require 'rails_helper'

RSpec.describe Tasks::Complete, type: :service do
  let(:user) { create(:user, :with_email_address, :with_valid_password) }
  let(:another_user) { create(:user, :with_email_address, :with_valid_password) }
  let(:category) { create(:category, user: user) }
  let(:task) { create(:task, :in_progress, user: user, completed_at: nil, category: category) }

  subject(:service_call) { described_class.call(task, current_user) }

  context "when user is the task owner" do
    let(:current_user) { user }

    context "and the task is not completed" do
      it "marks the task as completed" do
        result = service_call

        expect(result).to be_success
        expect(result.value).to eq("Task marked as completed.")
        expect(task.reload.completed_at).not_to be_nil
      end
    end

    context "and the task is already completed" do
      before do
        task.update!(completed_at: 1.day.ago)
      end

      it "fails with an error" do
        result = service_call

        expect(result).not_to be_success
        expect(result.error).to eq("Task is already completed.")
        # completed_at remains unchanged
        expect(task.reload.completed_at).not_to be_nil
      end
    end
  end

  context "when user is not the task owner" do
    let(:current_user) { another_user }

    it "fails with an authorization error" do
      result = service_call

      expect(result).not_to be_success
      expect(result.error).to eq("You are not allowed to complete this task.")
      # the task remains incomplete
      expect(task.reload.completed_at).to be_nil
    end
  end

  context "when task update fails for some unexpected reason" do
    let(:current_user) { user }

    it "fails with a generic error message" do
      # Force an update failure by stubbing
      allow(task).to receive(:update).and_return(false)

      result = service_call

      expect(result).not_to be_success
      expect(result.error).to eq("Failed to mark task as completed.")
      expect(task.reload.completed_at).to be_nil
    end
  end
end
