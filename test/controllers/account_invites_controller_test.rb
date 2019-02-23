require 'test_helper'

class AccountInvitesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionMailer::TestHelper

  def setup
    @user = users(:zack)
    @other_user = users(:fred)
    @account = @user.owned_accounts.first
    @second_account = @user.owned_accounts.last
    @invite = AccountInvite.new(account: @account, invite_email: @other_user.email)
    @invite.save
  end

  test "should get new when logged in" do
    sign_in @user
    get new_account_invite_url
    assert_response :success
  end

  test "should not get new when not logged in" do
    get new_account_invite_url
    assert_redirected_to new_user_session_url
  end

  test "should create an invite for owned account when logged in" do
    sign_in @user
    assert_difference('AccountInvite.count') do
      post account_invites_url, params: { account_invite: {
        account_id: @second_account.id,
        invite_email: 'test@example.com'
      } }
    end

    assert_redirected_to user_account_url(@user, @second_account)
  end

  test "should send an email to target owner when transfer is created" do
    skip "assert_enqueued_email_with looks for deliver_now"

    sign_in @user
    assert_enqueued_email_with AccountInviteMailer, :transfer_request do
      post account_invites_url, params: { account_invite: {
        account_id: @second_account.id,
        invite_email: 'test@example.com'
      } }
    end
  end

  test "should not create an invite when one is already pending for that user" do
    sign_in @user
    assert_no_difference('AccountInvite.count') do
      post account_invites_url, params: { account_invite: {
        account_id: @invite.account.id,
        invite_email: @invite.invite_email
      } }
    end

    assert_response :forbidden
  end

  test "should not create an invite for owned account when not logged in" do
    assert_no_difference('AccountInvite.count') do
      post account_invites_url, params: { account_invite: {
        account_id: @invite.account.id,
        invite_email: @invite.invite_email
      } }
    end

    assert_redirected_to new_user_session_url
  end

  test "should not create an invite for non-owned account" do
    sign_in @other_user
    assert_no_difference('AccountInvite.count') do
      post account_invites_url, params: { account_invite: {
        account_id: @account.id,
        invite_email: 'test@example.com'
      } }
    end

    assert_response :forbidden
  end

  test "should not show an invite when not logged in" do
    get account_invite_url @invite
    assert_redirected_to new_user_session_url
  end

  test "should show an invite when using the response token" do
    get account_invite_url(@invite, response_token: @invite.response_token)
    assert_response :success
  end

  test "should accept invite when logged in" do
    sign_in @other_user
    get accept_account_invite_url(@invite, response_token: @invite.response_token), params: { response_token: @invite.response_token }
    @invite.reload
    assert_equal 'accepted', @invite.response
    assert_redirected_to [@other_user, @invite.account]
  end

  test "should add member when invite accepted" do
    sign_in @other_user
    get accept_account_invite_url(@invite, response_token: @invite.response_token), params: { response_token: @invite.response_token }
    @invite.reload
    assert_equal 'accepted', @invite.response
    assert @invite.account.users.include?(@other_user)
  end

  test "should redirect to sign in when accepting and not logged in with a response token" do
    get accept_account_invite_url(@invite, response_token: @invite.response_token), params: { account_invite: { response: 'accept' } }
    assert_redirected_to new_user_session_url
  end

  test "should reject invite when not logged in with a response token" do
    get reject_account_invite_url(@invite, response_token: @invite.response_token), params: { account_invite: { response: 'reject' } }
    @invite.reload
    assert_equal 'rejected', @invite.response
    assert_redirected_to account_invite_url(@invite)
  end

  test "should not accept invite when not logged in and without response_token" do
    get accept_account_invite_url @invite, params: { account_invite: { response: 'accept'} }
    assert_redirected_to new_user_session_url
  end

  test "should not reject invite when not logged in and without response_token" do
    get reject_account_invite_url @invite, params: { account_invite: { response: 'accept'} }
    assert_redirected_to new_user_session_url
  end

end
