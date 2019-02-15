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

  test "it should report daily unique users" do
    site = sites(:three)
    for i in 0..4
      hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
      hit.save
    end

    travel_to Date.yesterday do
      for i in 5..10
        hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
        hit.save
      end
    end

    hits = site.hits_by_day
    assert_equal 5, hits[-1].num_hits
    assert_equal 6, hits[-2].num_hits
  end

  test "it should report unique users for 30 days" do
    site = sites(:three)
    hits = site.hits_by_day
    assert_equal 30, hits.size
  end

  test "it should aggregate identical client_ids in daily unique users" do
    site = sites(:three)
    4.times do
      hit = site.hits.build(client_id: 'some_id', tracking_id: site.tracking_id)
      hit.save
    end

    day_hits = site.hits_by_day
    assert_equal 1, day_hits.last.num_hits

    week_hits = site.hits_by_week
    assert_equal 1, week_hits.last.num_hits

    month_hits = site.hits_by_month
    assert_equal 1, month_hits.last.num_hits
  end

  test "it should report weekly unique users" do
    site = sites(:three)
    for i in 0..4
      hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
      hit.save
    end

    travel_to 1.day.ago do
      for i in 5..10
        hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
        hit.save
      end
    end

    travel_to 1.week.ago do
      for i in 11..15
        hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
        hit.save
      end
    end

    hits = site.hits_by_week
    assert_equal 11, hits[-1].num_hits
    assert_equal 5, hits[-2].num_hits
  end

  test "it should report unique users for 12 weeks" do
    site = sites(:three)
    hits = site.hits_by_week
    assert_equal 12, hits.size
  end

  test "it should report monthly unique users" do
    site = sites(:three)
    for i in 0..4
      hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
      hit.save
    end

    travel_to 1.day.ago do
      for i in 5..10
        hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
        hit.save
      end
    end

    travel_to 1.week.ago do
      for i in 11..15
        hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
        hit.save
      end
    end

    travel_to 1.month.ago do
      for i in 16..25
        hit = site.hits.build(client_id: i.to_s, tracking_id: site.tracking_id)
        hit.save
      end
    end

    hits = site.hits_by_month
    assert_equal 16, hits[-1].num_hits
    assert_equal 10, hits[-2].num_hits
  end

  test "it should report unique users for 12 months" do
    site = sites(:three)
    hits = site.hits_by_month
    assert_equal 12, hits.size
  end

end
