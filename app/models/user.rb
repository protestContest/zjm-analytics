class User < ApplicationRecord
  include Gravtastic
  gravtastic

  has_many :sites, dependent: :destroy
  has_and_belongs_to_many :accounts

  after_create :create_default_account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, password_length: 8..128

  private

    def create_default_account
      account = self.accounts.build(name: 'Personal')
      account.save
    end
end
