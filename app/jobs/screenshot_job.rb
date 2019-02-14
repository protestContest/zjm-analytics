require 'selenium-webdriver'
require 'aws-sdk-s3'

class ScreenshotJob < ApplicationJob
  queue_as :default

  def perform(site)
    if !site.url
      return
    end

    file_name = Digest::MD5.hexdigest(site.url) + ".png"
    tmp_file = "/tmp/#{file_name}"

    begin
      caps = Selenium::WebDriver::Remote::Capabilities.send("chrome")
      driver = Selenium::WebDriver.for :remote, url: Rails.configuration.screenshots_url, desired_capabilities: caps
      driver.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 768)
      driver.get site.url
      driver.save_screenshot tmp_file

      creds = Aws::Credentials.new(Rails.application.secrets.s3_access_key, Rails.application.secrets.s3_access_secret)
      s3 = Aws::S3::Resource.new(region: 'us-west-2', credentials: creds)

      bucket = Rails.configuration.screenshots_bucket
      obj = s3.bucket(bucket).object(file_name)
      obj.upload_file(tmp_file)

      site.screenshot_url = obj.public_url
      site.save
    ensure
      driver.quit
      File.delete(tmp_file)
    end
  end
end
