module SeleniumDownloadHelper
  class TimeoutError < StandardError
    def initialize(error, download_path)
      @download_path = download_path
      super("#{error.message}\nDownloaded files:\n#{downloaded_files.join("\n")}")
    end

    def downloaded_files
      Dir[File.join(@download_path, '*')]
    end
  end
end
