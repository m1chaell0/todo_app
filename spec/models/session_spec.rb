require "rails_helper"

describe Session, type: :model do
  describe "Associations" do
    context "belongs_to associations" do
      it { should belong_to(:user) }
    end
  end
end
