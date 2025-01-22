require 'rails_helper'

RSpec.describe Users::ChangePassword, type: :model do
  let(:user) { create(:user, :with_valid_password, :with_email_address) }
  subject(:form) { ActiveType.cast(user, described_class) }
  let(:password_params) { { current_password: current_password, new_password: new_password,
                            new_password_confirmation: new_password_confirmation } }
  let(:current_password) { 'password' }
  let(:new_password) { 'new_password123' }
  let(:new_password_confirmation) { new_password }

  describe "validations" do
    context "with valid attributes" do
      it "is valid and updates the user's password" do
        form.update(password_params)
        expect(BCrypt::Password.new(user.password_digest)).to eq(new_password)
      end
    end

    context "when current_password is blank" do
      let(:current_password) { nil }

      it "is invalid" do
        form.update(password_params)
        expect(form).not_to be_valid
        expect(form.errors[:current_password]).to include("can't be blank")
      end
    end

    context "when current_password is incorrect" do
      let(:current_password) { 'wrong_password' }

      it "is invalid" do
        form.update(password_params)
        expect(form).not_to be_valid
        expect(form.errors[:current_password]).to include("is incorrect")
      end
    end

    context "when new_password is blank" do
      let(:new_password) { nil }

      it "is invalid" do
        form.update(password_params)
        expect(form).not_to be_valid
        expect(form.errors[:new_password]).to include("can't be blank")
      end
    end

    context "when new_password is too short" do
      let(:new_password) { 'short' }

      it "is invalid" do
        form.update(password_params)
        expect(form).not_to be_valid
        expect(form.errors[:new_password]).to include("is too short (minimum is 6 characters)")
      end
    end

    context "when new_password does not match confirmation" do
      let(:new_password_confirmation) { 'mismatched_password' }

      it "is invalid" do
        form.update(password_params)
        expect(form).not_to be_valid
        expect(form.errors[:new_password_confirmation]).to include("doesn't match New password")
      end
    end

    context "when new_password is the same as current_password" do
      let(:new_password) { current_password }

      it "is invalid" do
        form.update(password_params)
        expect(form).not_to be_valid
        expect(form.errors[:new_password]).to include("must be different from your current password")
      end
    end
  end
end
