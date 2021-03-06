# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'
require 'selenium-webdriver'
require 'active_support/concern'
require_relative 'selenium_download_helper/version'

module SeleniumDownloadHelper
  extend ActiveSupport::Concern

  included do
    after(:all) do
      FileUtils.rm_rf(base_download_dir)
    end
  end

  def wait_for_downloaded(timeout: 10, interval: 0.2, all: false, &block)
    download_path= mkdownloaddir
    page.driver.browser.download_path = download_path
    yield
    Selenium::WebDriver::Wait.new(timeout: timeout, interval: interval).until { downloaded?(download_path) }
    downloaded_files(download_path).then { |files| all ? files : files.first }
  end

  private

    def base_download_dir
      Rails.root.join('tmp/data/downloads')
    end

    def mkdownloaddir
      FileUtils.mkdir_p(base_download_dir)
      Dir.mktmpdir('selenium_download_helper__', base_download_dir)
    end

    def downloaded_files(download_path)
      Dir[File.join(download_path, '*')].map { |filepath| Pathname.new(filepath) }
    end

    def downloaded?(download_path)
      files = downloaded_files(download_path)
      files.map(&:to_s).grep(/\.crdownload$/).none? && files.any?
    end
end
