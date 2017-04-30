require "csv_separator_detector/version"
require 'csv'

class CsvSeparatorDetector
  class Error < StandardError;
  end

  attr_reader :csv_text

  def initialize(csv_text)
    @csv_text = csv_text
  end

  def call
    separator_with_most_columns or fail CsvSeparatorDetector::Error
  end

  def supported_separators
    [',', ';', "\t", '|']
  end

  private

  # when two separators are equally good (produce the same amount of columns),
  # return neither of them.
  def separator_with_most_columns
    counts = count_columns_for_separators

    top_separators = counts.max_by(&:first).last
    top_separators.first if top_separators.length == 1
  end

  # returns
  # {
  #   2 => [',', ';'],
  #   0 => ['\t']
  # }
  def count_columns_for_separators
    supported_separators.each_with_object({}) do |sep, memo|
      begin
        columns              = ::CSV.parse_line(csv_text, col_sep: sep)
        memo[columns.length] ||= []
        memo[columns.length] << sep
      rescue ::CSV::MalformedCSVError
        # do nothing
      end
    end
  end
end