class Account < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :owner_id

end
