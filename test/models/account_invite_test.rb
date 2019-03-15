require 'test_helper'

class AccountInviteTest < ActiveSupport::TestCase
  def setup
    @user = users(:zack)
    @other_user = users(:fred)
    @account = @user.owned_accounts.first
    @invite = AccountInvite.new(account: @account, invite_email: @other_user.email)
  end

  test "should be valid" do
    assert @invite.valid?
  end

  test "should create a response token on create" do
    @invite.save
    assert_not @invite.response_token.nil?
  end

  test "response should be pending when created" do
    @invite.save
    assert @invite.pending?
  end

  test "should be able to be accepted if pending" do
    @invite.save
    @invite.accept!
    assert @invite.accepted?
  end

  test "should be able to be rejected if pending" do
    @invite.save
    @invite.reject!
    assert @invite.rejected?
  end

  test "should not be able to be accepted if rejected" do
    @invite.reject!
    @invite.accept!
    assert @invite.rejected?
  end

  test "should not be able to be rejected if accepted" do
    @invite.accept!
    @invite.reject!
    assert @invite.accepted?
  end

  test "should add responded_at for accepted and rejected invites" do
    dup_invite = @invite.dup

    @invite.accept!
    assert_not @invite.responded_at.nil?

    dup_invite.reject!
    assert_not dup_invite.responded_at.nil?
  end
end
