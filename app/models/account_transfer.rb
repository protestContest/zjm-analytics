class AccountTransfer < ApplicationRecord
  enum response: [:pending, :accepted, :rejected]
  belongs_to :account
  belongs_to :original_owner, class_name: 'User'
  belongs_to :target_owner, class_name: 'User'

  before_create :create_response_token

  def accept!
    return false if self.response != 'pending'
    self.responded_at = DateTime.now
    self.force_accept!
  end

  def reject!
    return false if self.response != 'pending'
    self.responded_at = DateTime.now
    self.force_reject!
  end

  private

    def create_response_token
      self.response_token = Devise.friendly_token
    end

  alias_method :force_accept!, :accepted!
  alias_method :force_reject!, :rejected!
  undef_method :accepted!
  undef_method :rejected!
  undef_method :pending!
end
