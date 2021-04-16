# frozen_string_literal: true

require_relative "selenium_download_helper/version"

module SeleniumDownloadHelper
  DOWNLOAD_PATH = defined? Rails ? Rails.root.join('tmp/data/downloads').to_s : Pathname.new(Dir.tmpdir)

  def download_path
    File.join(DOWNLOAD_PATH, Thread.current.object_id.to_s)
  end

  def downloaded_files
    Dir[File.join(download_path, '*')].map { |filepath| Pathname.new(filepath) }
  end

  def downloaded?
    downloaded_files.grep(/\.crdownload$/).none? && downloaded_files.any?
  end

  def delete_all_downloaded_files
    FileUtils.rm_f(downloaded_files)
  end

  def wait_for_downloaded(timeout: 20, interval: 0.2, all: false, &block)
    page.driver.browser.download_path = download_path

    delete_all_downloaded_files
    Selenium::WebDriver::Wait.new(timeout: timeout, interval: interval).until { downloaded? }

    if block_given?
      yield(all ? downloaded_files : downloaded_files.first)
    end

    delete_all_downloaded_files
  end
end
