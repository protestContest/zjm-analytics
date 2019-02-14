require 'test_helper'

class ScreenshotJobTest < ActiveJob::TestCase
  test "it saves a screenshot" do
    skip "WebDriver and S3 need to be mocked"

    site = sites(:one)
    ScreenshotJob.perform_now(site)
    assert File.exists? '/tmp/screenshot.png'
  end
end
