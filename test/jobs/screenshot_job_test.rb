require 'test_helper'

class ScreenshotJobTest < ActiveJob::TestCase
  test "the truth" do
    ScreenshotJob.perform_now('http://example.com')
    assert File.exists? '/tmp/screenshot.png'
  end
end
