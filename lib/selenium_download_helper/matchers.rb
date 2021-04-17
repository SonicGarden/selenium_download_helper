# frozen_string_literal: true

module SeleniumDownloadHelper
  module Matchers
    # NOTE: Workaround for environments where file names with non-ASCII characters are "download".
    RSpec::Matchers.define :have_basename do |expected|
      match do |file|
        expected_basename =
          if file.basename.to_s == 'download'
            'download'
          else
            expected
          end
        file.basename.to_s === expected_basename # rubocop:disable Style/CaseEquality
      end
      failure_message do |file|
        "expected: \"#{expected}\" got: \"#{file.basename}\" (compared using ===)"
      end
    end

    RSpec::Matchers.define :have_extname do |expected|
      match do |file|
        expected_extname =
          if file.basename.to_s == 'download'
            ''
          else
            expected
          end
        file.extname === expected_extname # rubocop:disable Style/CaseEquality
      end
      failure_message do |file|
        "expected: \"#{expected}\" got: \"#{file.extname}\" (compared using ===)"
      end
    end
  end
end
