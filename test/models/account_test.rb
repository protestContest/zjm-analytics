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

  test "name should be unique for a user" do
    dup_account = @account.dup
    @account.save
    assert_not dup_account.valid?
  end

  test "name can be reused for different users" do
    fred = users(:fred)
    fred_account = fred.owned_accounts.build(name: @account.name)
    @account.save
    assert fred_account.valid?
  end
end
