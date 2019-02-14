require 'selenium-webdriver'
require 'aws-sdk'

class ScreenshotJob < ApplicationJob
  queue_as :default

  def perform(url)
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.send("chrome")
      driver = Selenium::WebDriver.for :remote, url: Rails.configuration.screenshots_url, desired_capabilities: caps
      driver.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 768)
      driver.get url
      driver.save_screenshot '/tmp/screenshot.png'

      creds = Aws::Credentials.new(Rails.application.secrets.s3_access_key, Rails.application.secrets.s3_access_secret)
      s3 = Aws::S3::Resource.new(region: 'us-west-2', credentials: creds)

      file = '/tmp/screenshot.png'
      bucket = Rails.configuration.screenshots_bucket
      name = File.basename(file)
      obj = s3.bucket(bucket).object(name)
      obj.upload_file(file)

    ensure
      driver.quit
    end
  end
end
