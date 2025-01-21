require "rails_helper"

RSpec.describe Tasks::Update, type: :model do
  let(:user) { create(:user, :with_email_address, :with_valid_password) }
  let(:category) { create(:category, user: user) }
  let(:task) { create(:task, user: user, end_time: 2.days.from_now, start_time: 2.days.ago, category: category) }

  subject(:form) { ActiveType.cast(task, described_class) }

  before do
    form.id = task.id
  end

  describe "#save" do
    context "when user_id changes" do
      before { form.user_id = create(:user, :with_email_address, :with_valid_password).id }

      it "fails validation" do
        expect(form.save).to eq(false)
        expect(form.errors.full_messages).to include("You cannot edit this task")
      end
    end

    context "when end_time is set in the past" do
      before { form.end_time = 1.day.ago }

      it "fails validation for end_time" do
        expect(form.save).to eq(false)
        expect(form.errors[:end_time]).to include("must be in the future")
      end
    end

    context "when start_time changes while task is in progress" do

      before do
        form.start_time = 5.days.ago        # new start time is earlier
        form.end_time = 3.days.from_now     # new end time is in the future
      end

      it "fails validation because start_time cannot move backward" do
        # We expect 'start_time_changed?' and 'start_time_was > start_time'
        expect(form.save).to eq(false)
        expect(form.errors[:start_time]).to include("cannot be changed while task is in progress")
      end
    end

    context "with valid attributes" do
      before do
        form.end_time = 5.days.from_now
      end

      it "updates the task successfully" do
        expect(form.save).to eq(true)
        expect(form).to be_persisted
        expect(form.end_time).to be > Time.current

        expect(task.reload.end_time).to be_within(1.second).of(form.end_time)
      end
    end
  end
end
