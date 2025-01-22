require 'rails_helper'

RSpec.describe Users::Update, type: :model do
  let(:user) { create(:user, :with_email_address, :with_valid_password) }

  subject(:form) { ActiveType.cast(user, described_class) }
  before do
    form.id = user.id
    form.update(attributes)
  end

  let(:attributes) do
    {
      email_address: email_address,
      password: password,
      password_confirmation: password_confirmation
    }
  end

  let(:email_address) { 'new@example.com' }
  let(:password) { "password" }
  let(:password_confirmation) { "password" }

  describe "validations" do
    context "with valid attributes" do
      let(:email_address) { 'new@example.com' }

      it "is valid and updates the user's email address" do
        expect(user.reload.email_address).to eq('new@example.com')
      end
    end

    context "when email_address is blank" do
      let(:email_address) { nil }

      it "is invalid" do
        expect(form).not_to be_valid
        expect(form.errors[:email_address]).to include("can't be blank")
      end
    end

    context "when email_address is improperly formatted" do
      let(:email_address) { 'invalid_email!qwe' }

      it "is invalid" do
        expect(form).not_to be_valid
        expect(form.errors[:email_address]).to include("is invalid")
      end
    end

    context "when password is blank" do
      let(:password) { nil }

      it "is invalid" do
        expect(form).not_to be_valid
        expect(form.errors[:password]).to include("can't be blank")
      end
    end

    context "when password is incorrect" do
      let(:password) { 'wrong_password' }

      it "is invalid" do
        expect(form).not_to be_valid
        expect(form.errors[:password]).to include("is incorrect")
      end
    end
  end

  # describe "email normalization" do
  #   let(:email_address) { 'NEW@Example.Com' }
  #
  #   it "normalizes the email address" do
  #     form.update(attributes)
  #     debugger
  #     expect(user.reload.email_address).to eq('new@example.com')
  #   end
  # end
end
