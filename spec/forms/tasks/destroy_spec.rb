require "rails_helper"

RSpec.describe Tasks::Destroy, type: :model do
  let(:user) { create(:user, :with_email_address, :with_valid_password) }
  let(:other_user) { create(:user, :with_email_address, :with_valid_password) }
  let(:category) { create(:category, user: user) }
  let(:task) { create(:task, :completed_overdue, user: user, category: category) }

  subject(:destroy_form) { ActiveType.cast(task, described_class) }

  before do
    destroy_form.id = task.id
    destroy_form.current_user = current_user
  end

  describe "#destroy" do
    context "when current_user is the owner" do
      let(:current_user) { user }

      it "destroys the task" do
        expect {
          destroy_form.destroy
        }.to change(Task, :count).by(-1)
      end
    end

    context "when current_user is not the owner" do
      let(:current_user) { other_user }

      it "does not destroy the task and adds an error" do
        expect {
          destroy_form.destroy
        }.not_to change(Task, :count)

        expect(destroy_form.errors.full_messages).to include("You cannot delete this task")
      end
    end
  end
end
