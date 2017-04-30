# CsvSeparatorDetector

![travis](https://travis-ci.org/stulentsev/csv_separator_detector.svg?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csv_separator_detector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_separator_detector

## Usage

``` ruby
begin
  content = File.read('/path/to/csv.file')
  separator = CsvSeparatorDetector.new(content).call # => ';'
rescue CsvSeparatorDetector::Error
  # we couldn't reliably determine separator.
end
```

## Explanation

This class knows a few common csv delimiters and tries to parse given content using them 
(by passing each delimiter as `col_sep` option to `CSV` from stdlib). Then it tries to make
 sense of the result. All rows turned out to be just one column wide? That's likely because 
 we used comma separator and the file is tab-delimited.
 
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stulentsev/csv_separator_detector.

