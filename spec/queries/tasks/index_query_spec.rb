require "rails_helper"

RSpec.describe Tasks::IndexQuery do
  let(:user) { create(:user, :with_valid_password, :with_email_address) }
  let(:categories) { create_list(:category, 3, user: user) }
  let(:tasks) do
    [
      create(:task, user: user, title: "Task A", start_time: 2.days.from_now, category: categories[0]),
      create(:task, user: user, title: "Task B", start_time: 1.day.from_now, category: categories[1]),
      create(:task, user: user, title: "Task C", start_time: 3.days.from_now, category: categories[2], completed_at: Time.current),
      create(:task, user: user, title: "Task D", start_time: 1.day.ago, category: categories[2])
    ]
  end
  before do
    tasks
  end

  let(:base_query) { described_class.new(user.tasks, params) }

  describe "#call" do
    subject { base_query.call }

    context "when no filters or sorting are applied" do
      let(:params) { {} }

      it "returns all active tasks sorted by start_time ascending by default" do
        pagy, result = subject
        expect(result.map(&:title)).to eq([ "Task D", "Task B", "Task A" ])
        expect(pagy).to be_a(Pagy)
      end
    end

    context "when filtering by status" do
      let(:params) { { status: "completed", display_expired: true } }

      it "returns only completed tasks" do
        _, result = subject
        expect(result).to match_array([ tasks[2] ])
      end
    end

    context "when searching by title" do
      let(:params) { { q: "Task B" } }

      it "returns tasks matching the search term" do
        _, result = subject
        expect(result).to match_array([ tasks[1] ])
      end
    end

    context "when sorting by title in descending order" do
      let(:params) { { sort: "title", direction: "desc" } }

      it "returns tasks sorted by title in descending order" do
        _, result = subject
        expect(result.map(&:title)).to eq([ "Task D", "Task B", "Task A" ])
      end
    end

    context "when sorting by category name" do
      let(:params) { { sort: "category", direction: "asc" } }

      it "sorts tasks by category name in ascending order" do
        _, result = subject
        expect(result.map(&:category)).to eq(categories.sort_by(&:name))
      end
    end

    context "when applying pagination" do
      let(:params) { { page: 1, per_page: 2 } }

      it "returns paginated tasks" do
        pagy, result = subject
        expect(result.size).to eq(2)
        expect(pagy.page).to eq(1)
        expect(result.map(&:title)).to eq([ "Task D", "Task B" ])
      end
    end

    context "when display_expired is true" do
      let(:params) { { display_expired: true } }

      it "includes expired tasks" do
        _, result = subject
        expect(result).to eq(user.tasks.order(start_time: :asc))
      end
    end

    context "when display_expired is false" do
      let(:params) { { display_expired: false } }

      it "excludes expired tasks" do
        _, result = subject
        expect(result).not_to include(tasks[2])
      end
    end
  end
end
