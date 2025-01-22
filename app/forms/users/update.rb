class Users::Update < ActiveType::Record[User]
  attribute :password, :string

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
  validate :entered_password_matches, if: -> { password.present? }

  private

  def entered_password_matches
    return if password.blank?

    unless BCrypt::Password.new(password_digest).is_password?(password)
      errors.add(:password, "is incorrect")
    end
  end
end
