class Account < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :users
  has_many :account_transfers, dependent: :destroy
  has_many :account_invites, dependent: :destroy
  has_many :sites, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :owner_id

  def includes_user? user
    if self.users.include? user
      return true
    end

    if self.owner == user
      return true
    end

    return false
  end
end
