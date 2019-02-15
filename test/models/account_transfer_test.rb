require 'test_helper'

class AccountTransferTest < ActiveSupport::TestCase
  def setup
    @user = users(:zack)
    @other_user = users(:fred)
    @account = @user.owned_accounts.first
    @transfer = AccountTransfer.new(account: @account, original_owner: @user, target_owner: @other_user.email)
  end

  test "should be valid" do
    assert @transfer.valid?
  end

  test "should create a response token on create" do
    @transfer.save
    assert_not @transfer.response_token.nil?
  end

  test "response should be pending when created" do
    @transfer.save
    assert @transfer.pending?
  end

  test "should be able to be accepted if pending" do
    @transfer.save
    @transfer.accept!
    assert @transfer.accepted?
  end

  test "should be able to be rejected if pending" do
    @transfer.save
    @transfer.reject!
    assert @transfer.rejected?
  end

  test "should not be able to be accepted if rejected" do
    @transfer.reject!
    @transfer.accept!
    assert @transfer.rejected?
  end

  test "should not be able to be rejected if accepted" do
    @transfer.accept!
    @transfer.reject!
    assert @transfer.accepted?
  end

  test "should add responded_at for accepted and rejected transfers" do
    dup_transfer = @transfer.dup

    @transfer.accept!
    assert_not @transfer.responded_at.nil?

    dup_transfer.reject!
    assert_not dup_transfer.responded_at.nil?
  end
end
