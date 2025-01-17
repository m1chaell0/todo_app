# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_user_id  (user_id)
#

class Category < ApplicationRecord
  belongs_to :user, optional: true
  has_many :tasks

  validates :name, presence: true
end
