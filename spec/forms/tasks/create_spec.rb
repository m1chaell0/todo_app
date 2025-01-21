require 'rails_helper'

RSpec.describe Tasks::Create, type: :model do
  let(:user) { create(:user, :with_email_address, :with_valid_password) }
  let(:user_category) { create(:category, user: user) }
  let(:common_category) { create(:category, user: nil) }

  subject(:form) { described_class.new(form_attributes) }

  describe "#save" do
    context "with valid attributes" do
      let(:form_attributes) do
        {
          user_id: user.id,
          category_id: user_category.id,
          title: "My Task",
          start_time: 2.days.from_now,
          end_time: 3.days.from_now
        }
      end

      it "creates a new task" do
        expect(form.save).to eq(true)
        expect(form).to be_persisted
        expect(form.errors).to be_empty

        created_task = Task.last
        expect(created_task.title).to eq("My Task")
        expect(created_task.user_id).to eq(user.id)
        expect(created_task.category_id).to eq(user_category.id)
        expect(created_task.start_time).to be > Time.current
      end
    end

    context "when category doesn't belong to user" do
      let(:another_user) { create(:user, :with_email_address, :with_valid_password) }
      let(:bad_category) { create(:category, user: another_user) }

      let(:form_attributes) do
        {
          user_id: user.id,
          category_id: bad_category.id,
          title: "Unauthorized Category",
          start_time: 1.day.from_now
        }
      end

      it "fails validation with 'is not accessible to you'" do
        expect(form.save).to eq(false)
        expect(form).not_to be_persisted
        expect(form.errors[:category_id]).to include("is not accessible to you")
      end
    end

    context "when start_time is in the past" do
      let(:form_attributes) do
        {
          user_id: user.id,
          category_id: user_category.id,
          title: "Invalid Time",
          start_time: 1.day.ago
        }
      end

      it "fails validation for start_time" do
        expect(form.save).to eq(false)
        expect(form.errors[:start_time]).to include("must be in the future")
      end
    end

    context "when end_time is in the past" do
      let(:form_attributes) do
        {
          user_id: user.id,
          category_id: user_category.id,
          title: "Invalid End Time",
          start_time: 2.days.from_now,
          end_time: 1.day.ago
        }
      end

      it "fails validation for end_time" do
        expect(form.save).to eq(false)
        expect(form.errors[:end_time]).to include("must be in the future")
      end
    end

    context "when category is nil but user_id is provided" do
      # Suppose the user tries to set a category that does not exist at all
      # or the field is just missing
      let(:form_attributes) do
        {
          user_id: user.id,
          category_id: nil,
          title: "No Category",
          start_time: 2.days.from_now
        }
      end

      it "fails because category is required at the DB or model level" do
        expect(form.save).to eq(false)
        expect(form.errors[:category]).to be_present
      end
    end
  end
end
