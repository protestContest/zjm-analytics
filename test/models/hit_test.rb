require 'test_helper'

class HitTest < ActiveSupport::TestCase
  def setup
    @user = users(:zack)
    @site = @user.sites.build(name: "Test Site")
    @hit = @site.hits.build(
      hit_type: 'pageview',
      location: 'http://example.com',
      language: 'en-US',
      encoding: 'UTF-8',
      title: 'Example Page',
      color_depth: 24,
      screen_res: '1440x900',
      viewport: '800x600',
      tracking_id: 'XXX-TEST',
      client_id: '1234'
    )
  end

  test "should be valid" do
    assert @hit.valid?
  end

end
