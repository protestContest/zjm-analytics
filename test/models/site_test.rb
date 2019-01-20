require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def setup
    @user = users(:zack)
    @site = @user.sites.build(name: "Site Name")
  end

  test "should be valid" do
    assert @site.valid?
  end

  test "name should be present" do
    @site.name = "   "
    assert_not @site.valid?
  end

  test "name should be unique for a user" do
    dup_site = @site.dup
    @site.save
    assert_not dup_site.valid?
  end

  test "name can be reused for different users" do
    fred = users(:fred)
    fred_site = fred.sites.build(name: @site.name)
    @site.save
    assert fred_site.valid?
  end
end
