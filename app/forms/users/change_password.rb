class Users::ChangePassword < ActiveType::Record[User]
  attribute :current_password, :string
  attribute :new_password, :string
  attribute :new_password_confirmation, :string

  validates :current_password, presence: true
  validates :new_password, confirmation: true, presence: true, length: { minimum: 6 }
  validate :entered_password_matches
  validate :new_password_different_from_current
  before_validation :set_bcrypt_password

  private

  def set_bcrypt_password
    self.password_digest = BCrypt::Password.create(new_password) if new_password.present?
  end

  def entered_password_matches
    return if current_password.blank?

    unless BCrypt::Password.new(password_digest).is_password?(current_password)
      errors.add(:current_password, "is incorrect")
    end
  end

  def new_password_different_from_current
    errors.add(:new_password, "must be different from your current password") if current_password == new_password
  end
end
