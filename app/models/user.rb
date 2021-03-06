class User < ApplicationRecord
  include Gravtastic
  gravtastic

  has_many :owned_accounts, class_name: 'Account', foreign_key: 'owner_id', dependent: :destroy
  has_and_belongs_to_many :accounts
  has_many :account_transfer_requests, class_name: 'AccountTransfer', foreign_key: 'original_owner', dependent: :destroy

  has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  after_create :create_default_owned_account

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :doorkeeper,
         :recoverable, :rememberable, :validatable, password_length: 8..128

  def has_account account
    self == account.owner || account.users.include?(self)
  end

  def all_accounts
    (self.owned_accounts + self.accounts).sort_by(&:name)
  end

  private

    def create_default_owned_account
      account = self.owned_accounts.build(name: 'Personal')
      account.save
    end
end
