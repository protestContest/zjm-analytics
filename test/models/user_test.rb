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
end
