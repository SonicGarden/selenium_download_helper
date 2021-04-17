# selenium_download_helper

Selenium download helper

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'selenium_download_helper', github: 'SonicGarden/selenium_download_helper'
end
```

And then execute:

    $ bundle install

## Usage

```ruby
RSpec.configure do |config|
  config.include SeleniumDownloadHelper, type: :system
end
```

```ruby
it 'Download files' do
  visit export_path
  file = wait_for_downloaded { click_on 'Export' }
  expect(file.basename.to_s).to eq 'export.txt'
  expect(file.extname).to eq  '.txt'
  expect(file.read).to eq 'Export!'
end
```

## Browser support

- Chrome

**NOTE:** If non-ascii file names are not saved correctly, set the locale.

```yaml
- name: Set Locale
  run: |
    sudo locale-gen ja_JP.UTF-8
    sudo update-locale LANG=ja_JP.UTF-8
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SonicGarden/selenium_download_helper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/selenium_download_helper/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SeleniumDownloadHelper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/selenium_download_helper/blob/master/CODE_OF_CONDUCT.md).
