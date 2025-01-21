# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string           not null
#  last_name       :string           not null
#  email_address   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#

require 'rails_helper'
describe User, type: :model do
  describe "Associations" do
    context "has_many associations" do
      it { should have_many(:categories) }
      it { should have_many(:tasks) }
      it { should have_many(:sessions) }
    end
  end

  describe "Validations" do
    before do
      create(:user, :with_valid_password, :with_email_address) # Create an existing valid user
    end
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email_address) }
    it { should validate_uniqueness_of(:email_address) }
  end

  describe "Methods" do
    it "has a full name" do
      user = create(:user, :with_email_address, :with_valid_password)
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end
