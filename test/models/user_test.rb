require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: 'asdf@example.com', password: 'password')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "password length should be at least 8" do
    @user.password = "asdfasd"
    assert_not @user.valid?
    @user.password = "asdfasdf"
    assert @user.valid?
  end

  test "creating a user also creates an owned account" do
    user = User.new(email: 'newuser@example.com', password: 'password')
    user.save

    assert_equal 1, user.owned_accounts.size
  end

  test "has_account is true for owned accounts and accounts user is a member of" do
    user = users(:zack)
    owned_account = user.owned_accounts.first
    other_account = accounts(:two)

    user.accounts << other_account

    assert user.has_account owned_account
    assert user.has_account other_account
  end

end
