# frozen_string_literal: true

require_relative "selenium_download_helper/version"

module SeleniumDownloadHelper
  extend ActiveSupport::Concern

  DOWNLOAD_BASE_DIR = 'tmp/data/downloads'
  private_constant :DOWNLOAD_BASE_DIR

  included do
    after(:all) do
      FileUtils.rm_rf(Rails.root.join(DOWNLOAD_BASE_DIR))
    end
  end

  def wait_for_downloaded(timeout: 10, interval: 0.2, all: false, &block)
    download_path= mkdownloaddir
    page.driver.browser.download_path = download_path
    yield if block_given?
    Selenium::WebDriver::Wait.new(timeout: timeout, interval: interval).until { downloaded?(download_path) }
    downloaded_files(download_path).then { |files| all ? files : files.first }
  end

  private

    def mkdownloaddir
      Dir.mktmpdir('SeleniumDownloadHelper_', Rails.root.join(DOWNLOAD_BASE_DIR))
    end

    def downloaded_files(download_path)
      Dir[File.join(download_path, '*')].map { |filepath| Pathname.new(filepath) }
    end

    def downloaded?(download_path)
      files = downloaded_files(download_path)
      files.map(&:to_s).grep(/\.crdownload$/).none? && files.any?
    end
end
