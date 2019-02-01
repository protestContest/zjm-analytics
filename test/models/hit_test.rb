require 'test_helper'

class HitTest < ActiveSupport::TestCase
  test "should be valid" do
    site = sites(:one)

    hit = site.hits.build({
      hit_type: 'data',
      location: 'data',
      language: 'data',
      encoding: 'data',
      title: 'data',
      color_depth: 'data',
      screen_res: 'data',
      viewport: 'data',
      tracking_id: site.tracking_id,
      client_id: 'data'
    })

    assert hit.valid?
  end
end
