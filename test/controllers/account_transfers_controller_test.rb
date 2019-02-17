require 'test_helper'

class AccountTransfersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:zack)
    @other_user = users(:fred)
    @account = @user.owned_accounts.first
    @second_account = @user.owned_accounts.last
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
    assert_not_equal @account, @second_account
    assert_difference('AccountTransfer.count') do
      post account_transfers_url, params: { account_transfer: {
        account_id: @second_account.id,
        target_owner: 'test@example.com'
      } }
    end

    assert_redirected_to user_account_url(@user, @second_account)
  end

  test "should not create a transfer for last owned account" do
    assert_equal 1, @other_user.owned_accounts.size
    sign_in @other_user
    assert_no_difference('AccountTransfer.count') do
      post account_transfers_url, params: { account_transfer: {
        account_id: @other_user.owned_accounts.first.id,
        target_owner: 'test@example.com'
      } }
    end

    assert_response :forbidden
  end

  test "should not create a transfer when one is already pending" do
    sign_in @user
    assert_no_difference('AccountTransfer.count') do
      post account_transfers_url, params: { account_transfer: {
        account_id: @account.id,
        target_owner: 'test@example.com'
      } }
    end

    assert_response :forbidden
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

  test "should show a transfer when using the response token" do
    get account_transfer_url(@transfer, response_token: @transfer.response_token)
    assert_response :success
  end

  test "should accept transfer when logged in" do
    sign_in @other_user
    get accept_account_transfer_url(@transfer, response_token: @transfer.response_token), params: { response_token: @transfer.response_token }
    @transfer.reload
    assert_equal 'accepted', @transfer.response
    assert_redirected_to [@other_user, @transfer.account]
  end

  test "should change account owner when transfer accepted" do
    sign_in @other_user
    get accept_account_transfer_url(@transfer, response_token: @transfer.response_token), params: { response_token: @transfer.response_token }
    @transfer.reload
    assert_equal 'accepted', @transfer.response
    assert_equal @other_user, @transfer.account.owner
  end

  test "should redirect to sign in when accepting and not logged in with a response token" do
    get accept_account_transfer_url(@transfer, response_token: @transfer.response_token), params: { account_transfer: { response: 'accept' } }
    assert_redirected_to new_user_session_url
  end

  test "should reject transfer when not logged in with a response token" do
    get reject_account_transfer_url(@transfer, response_token: @transfer.response_token), params: { account_transfer: { response: 'reject' } }
    @transfer.reload
    assert_equal 'rejected', @transfer.response
    assert_redirected_to account_transfer_url(@transfer)
  end

  test "should not accept transfer when not logged in and without response_token" do
    get accept_account_transfer_url @transfer, params: { account_transfer: { response: 'accept'} }
    assert_redirected_to new_user_session_url
  end

  test "should not reject transfer when not logged in and without response_token" do
    get reject_account_transfer_url @transfer, params: { account_transfer: { response: 'accept'} }
    assert_redirected_to new_user_session_url
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
