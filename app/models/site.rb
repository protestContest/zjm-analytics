class Site < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :user_id
end
