require "rails_helper"

describe Category, type: :model do
  describe "Associations" do
    context "has_many associations" do
      it { should have_many(:tasks) }
    end
  end
end
