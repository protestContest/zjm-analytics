require 'test_helper'

class AccountTransfersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:zack)
    @other_user = users(:fred)
    @account = @user.owned_accounts.first
    @transfer = AccountTransfer.new(account: @account, original_owner: @user, target_owner: @other_user.email)
    @transfer.save
  end

  test "should get new when logged in" do
    sign_in @user
    get new_account_transfer_url
    assert_response :success
  end

  test "should not get new when not logged in" do
    get new_account_transfer_url
    assert_redirected_to new_user_session_url
  end

  test "should create a transfer for owned account when logged in" do
    sign_in @user
    assert_difference('AccountTransfer.count') do
      post account_transfers_url, params: { account_transfer: {
        account_id: @account.id,
        target_owner: 'test@example.com'
      } }
    end

    assert_redirected_to account_transfer_url(AccountTransfer.last)
  end

  test "should not create a transfer for owned account when not logged in" do
    assert_no_difference('AccountTransfer.count') do
      post account_transfers_url, params: { account_transfer: {
        account_id: @account.id,
        target_owner: 'test@example.com'
      } }
    end

    assert_redirected_to new_user_session_url
  end

  test "should not create a transfer for non-owned account" do
    sign_in @other_user
    assert_no_difference('AccountTransfer.count') do
      post account_transfers_url, params: { account_transfer: {
        account_id: @account.id,
        target_owner: 'test@example.com'
      } }
    end

    assert_response :forbidden
  end

  test "should show a transfer user initiated" do
    assert_equal @user, @transfer.original_owner
    sign_in @user
    get account_transfer_url @transfer
    assert_response :success
  end

  test "should not show a transfer when not logged in" do
    get account_transfer_url @transfer
    assert_redirected_to new_user_session_url
  end

  test "should not show a transfer user did not initiate" do
    assert_not_equal @other_user, @transfer.original_owner
    sign_in @other_user
    get account_transfer_url @transfer
    assert_response :forbidden
  end

  test "should get edit for owned transfer when logged in" do
    sign_in @user
    get edit_account_transfer_url @transfer
    assert_response :success
  end

  test "should not get edit when not logged in" do
    get edit_account_transfer_url @transfer
    assert_redirected_to new_user_session_url
  end

  test "should not get edit when user did not initiate transfer" do
    sign_in @other_user
    get edit_account_transfer_url @transfer
    assert_response :forbidden
  end

  test "should update transfer when logged in" do
    sign_in @user
    patch account_transfer_url @transfer, params: { account_transfer: {
      account_id: @account.id,
      target_owner: 'newowner@example.com'
    } }
    assert_redirected_to account_transfer_url(@transfer)
  end

  test "should not update transfer when not logged in" do
    patch account_transfer_url @transfer, params: { account_transfer: {
      account_id: @account.id,
      target_owner: 'newowner@example.com'
    } }
    assert_redirected_to new_user_session_url
  end

  test "should not update transfer when user did not initiate" do
    sign_in @other_user
    patch account_transfer_url @transfer, params: { account_transfer: {
      account_id: @account.id,
      target_owner: 'newowner@example.com'
    } }
    assert_response :forbidden
  end

  test "should destroy transfer when logged in" do
    sign_in @user
    assert_difference('AccountTransfer.count', -1) do
      delete account_transfer_url(@transfer)
    end

    assert_redirected_to user_accounts_url(@user)
  end

  test "should not destroy transfer when not logged in" do
    assert_no_difference('Account.count') do
      delete account_transfer_url(@transfer)
    end

    assert_redirected_to new_user_session_url
  end

  test "should not destroy transfer when user did not initiate it" do
    sign_in @other_user
    assert_no_difference('Account.count') do
      delete account_transfer_url(@transfer)
    end

    assert_response :forbidden
  end
end
