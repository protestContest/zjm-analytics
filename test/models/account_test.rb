require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @user = users(:zack)
    @account = @user.owned_accounts.build(name: "Account Name")
  end

  test "should be valid" do
    assert @account.valid?
  end

  test "name should be present" do
    @account.name = "    "
    assert_not @account.valid?
  end
end
