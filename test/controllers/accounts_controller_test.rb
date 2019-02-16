require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:zack)
    @account = accounts(:one)
    @other_account = accounts(:two)
  end

  test "should get index when logged in" do
    sign_in @user
    get user_accounts_url @user
    assert_response :success
  end

  test "should not get index when not logged in" do
    get user_accounts_url @user
    assert_redirected_to new_user_session_url
  end

  test "should not get index for different user" do
    other_user = users(:fred)
    sign_in other_user
    get user_accounts_url @user
    assert_response :forbidden
  end

  test "should get new when logged in" do
    sign_in @user
    get new_user_account_url @user
    assert_response :success
  end

  test "should not get new when not logged in" do
    get new_user_account_url @user
    assert_redirected_to new_user_session_url
  end

  test "should create account when logged in" do
    sign_in @user
    assert_difference('Account.count') do
      post user_accounts_url @user, params: { account: { name: 'New Account' } }
    end

    assert_redirected_to user_account_url(@user, @user.owned_accounts.last)
  end

  test "should not create account when not logged in" do
    assert_no_difference('Account.count') do
      post user_accounts_url @user, params: { account: { name: 'New Account' } }
    end

    assert_redirected_to new_user_session_url
  end

  test "should show account user owns" do
    assert_equal @account.owner, @user
    sign_in @user
    get user_account_url(@user, @account)
    assert_response :success
  end

  test "should show account user is a member of" do
    user = users(:bette)
    @account.users << user
    @account.save

    sign_in user
    get user_account_url(user, @account)
    assert_response :success
  end

  test "should not show account when not logged in" do
    get user_account_url(@user, @account)
    assert_redirected_to new_user_session_url
  end

  test "should not show account if user is not part of account and does not own account" do
    sign_in @user
    get user_account_url(@user, @other_account)
    assert_response :forbidden
  end

  test "should get edit when logged in" do
    sign_in @user
    get edit_user_account_url(@user, @account)
    assert_response :success
  end

  test "should not get edit when not logged in" do
    get edit_user_account_url(@user, @account)
    assert_redirected_to new_user_session_url
  end

  test "should not get edit when user does not own account" do
    user = users(:bette)
    sign_in user
    get edit_user_account_url(user, @account)
    assert_response :forbidden
  end

  test "should update account when logged in" do
    sign_in @user
    patch user_account_url(@user, @account), params: { account: { name: 'new name' } }
    assert_redirected_to user_account_url(@user, @account)
  end

  test "should not update account when not logged in" do
    patch user_account_url(@user, @account), params: { account: { name: 'new name' } }
    assert_redirected_to new_user_session_url
  end

  test "should not update account when user does not own account" do
    user = users(:bette)
    sign_in user
    patch user_account_url(user, @account), params: { account: { name: 'new name' } }
    assert_response :forbidden
  end

  test "should destroy account when logged in" do
    sign_in @user
    assert_difference('Account.count', -1) do
      delete user_account_url(@user, @account)
    end

    assert_redirected_to user_accounts_url(@user)
  end

  test "should not destroy account when not logged in" do
    assert_no_difference('Account.count') do
      delete user_account_url(@user, @account)
    end

    assert_redirected_to new_user_session_url
  end

  test "should not destroy account when user does not own account" do
    user = users(:bette)
    sign_in user
    assert_no_difference('Account.count') do
      delete user_account_url(user, @account)
    end

    assert_response :forbidden
  end

  test "should not allow user to destroy last owned account" do
    user = users(:fred)
    account = user.owned_accounts.first

    assert_equal 1, user.owned_accounts.size
    sign_in user
    assert_no_difference('Account.count') do
      delete user_account_url(user, account)
    end

    assert_response :forbidden
  end

  test "should allow a user to switch to an account they are a member of" do
    sign_in @user
    get switch_account_url(@account)
    assert_redirected_to dashboard_path
  end

  test "should not allow switching accounts when not logged in" do
    get switch_account_url(@account)
    assert_redirected_to new_user_session_url
  end

  test "should not allow switching to an account user is not a member of" do
    sign_in users(:fred)
    get switch_account_url(@account)
    assert_response :forbidden
  end
end
