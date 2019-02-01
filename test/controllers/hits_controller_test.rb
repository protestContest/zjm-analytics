require 'test_helper'

class HitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hit = hits(:one)
  end

  test "should create hit for a site that exists" do
    assert_difference('Hit.count') do
      get tracking_url, params: {
        client_id: @hit.client_id,
        color_depth: @hit.color_depth,
        encoding: @hit.encoding,
        hit_type: @hit.hit_type,
        language: @hit.language,
        location: @hit.location,
        screen_res: @hit.screen_res,
        title: @hit.title,
        tracking_id: @hit.tracking_id,
        viewport: @hit.viewport
      }
    end

    assert_response :success
  end

end
