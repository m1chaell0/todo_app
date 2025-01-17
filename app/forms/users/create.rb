class Users::Create < ActiveType::Record[User]
  attribute :password_confirmation, :string
  attribute :password, :string

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }

end
