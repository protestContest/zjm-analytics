require 'selenium-webdriver'

class ScreenshotJob < ApplicationJob
  queue_as :default

  def perform(url)
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.send("chrome")
      driver = Selenium::WebDriver.for :remote, url: Rails.configuration.screenshots_url, desired_capabilities: caps
      driver.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 768)
      driver.get url
      driver.save_screenshot '/tmp/screenshot.png'
    ensure
      driver.quit
    end
  end
end
