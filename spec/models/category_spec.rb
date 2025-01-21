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

require "rails_helper"

describe Category, type: :model do
  describe "Associations" do
    context "has_many associations" do
      it { should have_many(:tasks) }
    end
  end
end
