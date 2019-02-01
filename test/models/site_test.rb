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

  test "tracking_id should be available for saved site" do
    assert_equal 1, @user.id
    @site.save
    tracking_id = "ZA-000001-#{@site.id}"

    assert_equal tracking_id, @site.tracking_id
  end

  test "it should parse a tracking_id" do
    tracking_id = 'ZA-000123-45'
    site_data = Site.parse_tracking_id tracking_id
    assert_equal 123, site_data[:user_id]
    assert_equal 45, site_data[:site_id]
  end

  test "it should return nil for an invalid tracking_id" do
    tracking_id = 'invalid'
    site_data = Site.parse_tracking_id tracking_id
    assert_nil site_data
  end
end
