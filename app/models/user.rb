class User < ApplicationRecord
  include Gravtastic
  gravtastic

  has_many :sites, dependent: :destroy
  has_many :owned_accounts, class_name: 'Account', foreign_key: 'owner_id', dependent: :destroy
  has_and_belongs_to_many :accounts

  after_create :create_default_owned_account

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, password_length: 8..128

  def has_account account
    self == account.owner || account.users.include?(self)
  end

  private

    def create_default_owned_account
      account = self.owned_accounts.build(name: 'Personal')
      account.save
    end
end
