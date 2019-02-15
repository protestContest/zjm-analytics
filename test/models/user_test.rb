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

  test "creating a user also creates an account" do
    user = User.new(email: 'newuser@example.com', password: 'password')
    user.save

    assert_equal 1, user.accounts.size
  end
end
