class MailingListSignup < ApplicationRecord
  validates_uniqueness_of :email
end
