class Account < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :users
  has_many :account_transfers, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :owner_id

end
