# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  ip_address :string
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#

require "rails_helper"

describe Session, type: :model do
  describe "Associations" do
    context "belongs_to associations" do
      it { should belong_to(:user) }
    end
  end
end
