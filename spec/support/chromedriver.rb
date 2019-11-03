require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new(download_prefs)
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :headless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.headless!
  options.add_argument "--window-size=1680,1050"

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :cookieless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_preference("profile.default_content_setting_values.cookies", 2)
  options.add_preference("profile.block_third_party_cookies", true)
  options.add_argument "--use-fake-device-for-media-stream"
  options.add_argument "--use-fake-ui-for-media-stream"

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV["BROWSER"].to_s.casecmp("chrome").zero?
      driven_by :chrome
    else
      driven_by :headless_chrome
    end
  end

  config.before(:each, type: :system, browser: :cookieless) do
    driven_by :cookieless_chrome
  end

  # This config is needed to test downloads and it's content
  config.before(:each, type: :system, browser: :chrome) do
    DownloadHelper.clear_downloads

    driven_by :chrome
  end
end

def download_prefs
  {
    prefs: {
      download: {
        directory_upgrade: true,
        prompt_for_download: false,
        default_directory: DownloadHelper::PATH.to_s,
      },
    },
  }
end
