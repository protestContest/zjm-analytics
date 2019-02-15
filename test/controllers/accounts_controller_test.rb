require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:zack)
    @account = accounts(:one)
    @other_account = accounts(:two)
  end

  test "should get new when logged in" do
    sign_in @user
    get new_account_url
    assert_response :success
  end

  test "should not get new when not logged in" do
    get new_account_url
    assert_redirected_to new_user_session_url
  end

  test "should create account when logged in" do
    sign_in @user
    assert_difference('Account.count') do
      post accounts_url, params: { account: { name: 'New Account' } }
    end

    assert_redirected_to account_url(Account.last)
  end

  test "should not create account when not logged in" do
    assert_no_difference('Account.count') do
      post accounts_url, params: { account: { name: 'New Account' } }
    end

    assert_redirected_to new_user_session_url
  end

  test "should show account user owns" do
    assert_equal @account.owner, @user
    sign_in @user
    get account_url(@account)
    assert_response :success
  end

  test "should show account user is a member of" do
    user = users(:bette)
    @account.users << user
    @account.save

    sign_in user
    get account_url(@account)
    assert_response :success
  end

  test "should not show account when not logged in" do
    get account_url(@account)
    assert_redirected_to new_user_session_url
  end

  test "should not show account if user is not part of account and does not own account" do
    sign_in @user
    get account_url(@other_account)
    assert_response :forbidden
  end

  test "should get edit when logged in" do
    sign_in @user
    get edit_account_url(@account)
    assert_response :success
  end

  test "should not get edit when not logged in" do
    get edit_account_url(@account)
    assert_redirected_to new_user_session_url
  end

  test "should not get edit when user does not own account" do
    sign_in users(:bette)
    get edit_account_url(@account)
    assert_response :forbidden
  end

  test "should update account when logged in" do
    sign_in @user
    patch account_url(@account), params: { account: { name: 'new name' } }
    assert_redirected_to account_url(@account)
  end

  test "should not update account when not logged in" do
    patch account_url(@account), params: { account: { name: 'new name' } }
    assert_redirected_to new_user_session_url
  end

  test "should not update account when user does not own account" do
    sign_in users(:bette)
    patch account_url(@account), params: { account: { name: 'new name' } }
    assert_response :forbidden
  end

  test "should destroy account when logged in" do
    sign_in @user
    assert_difference('Account.count', -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
  end

  test "should not destroy account when not logged in" do
    assert_no_difference('Account.count') do
      delete account_url(@account)
    end

    assert_redirected_to new_user_session_url
  end

  test "should not destroy account when user does not own account" do
    sign_in users(:bette)
    assert_no_difference('Account.count') do
      delete account_url(@account)
    end

    assert_response :forbidden
  end
end
