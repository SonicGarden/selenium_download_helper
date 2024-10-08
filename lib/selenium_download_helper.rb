# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'
require 'selenium-webdriver'
require 'active_support/concern'
require_relative 'selenium_download_helper/version'
require_relative 'selenium_download_helper/errors'

module SeleniumDownloadHelper
  extend ActiveSupport::Concern

  TEMPORARY_DOWNLOAD_FILENAME_PATTERN = /(\.crdownload|^downloads.html)$/


  included do
    after(:all) do
      FileUtils.rm_rf(base_download_dir)
    end
  end

  def wait_for_downloaded(timeout: 10, interval: 0.2, all: false, filename: nil, &block)
    download_path= mkdownloaddir
    page.driver.browser.download_path = download_path
    yield
    Selenium::WebDriver::Wait.new(timeout: timeout, interval: interval).until { downloaded?(download_path, filename:) }
    downloaded_files(download_path, filename:).then { |files| all ? files : files.first }
  rescue Selenium::WebDriver::Error::TimeoutError => e
    raise TimeoutError.new(e, download_path)
  end

  private

    def base_download_dir
      Rails.root.join('tmp/data/downloads')
    end

    def mkdownloaddir
      FileUtils.mkdir_p(base_download_dir)
      Dir.mktmpdir('selenium_download_helper__', base_download_dir)
    end

    def downloaded_files(download_path, filename: nil)
      Dir[File.join(download_path, '*')]
        .map { |filepath| Pathname.new(filepath) }
        .reject { |file| TEMPORARY_DOWNLOAD_FILENAME_PATTERN.match?(file.basename.to_s) }
        .select { |file| filename.nil? || filename === file.basename.to_s }
    end

    def downloaded?(download_path, filename: nil)
      downloaded_files(download_path, filename:).any?
    end
end
