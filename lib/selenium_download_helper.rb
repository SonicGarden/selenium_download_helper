# frozen_string_literal: true

require_relative "selenium_download_helper/matchers"
require_relative "selenium_download_helper/version"

module SeleniumDownloadHelper
  include Matchers

  def download_path
    File.join(Rails.root.join('tmp/data/downloads'), Thread.current.object_id.to_s)
  end

  def downloaded_files
    Dir[File.join(download_path, '*')].map { |filepath| Pathname.new(filepath) }
  end

  def downloaded?
    files = downloaded_files
    files.map(&:to_s).grep(/\.crdownload$/).none? && files.any?
  end

  def delete_downloaded_dir
    FileUtils.rm_rf(download_path)
  end

  def wait_for_downloaded(timeout: 10, interval: 0.2, all: false, &block)
    page.driver.browser.download_path = download_path
    delete_downloaded_dir
    yield if block_given?
    Selenium::WebDriver::Wait.new(timeout: timeout, interval: interval).until { downloaded? }
    at_exit { delete_downloaded_dir }
    all ? downloaded_files : downloaded_files.first
  end
end
