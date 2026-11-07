require "test_helper"

class Rexport::ExporterTest < ActiveSupport::TestCase

  test 'to_csv(force_quotes)' do
    Sample.create!(integer: 1)
    exporter = IntegerExporter.new(Sample.all)
    Rexport.config.csv_default_force_quotes = true
    assert_equal <<~CSV, exporter.to_csv
      "1"
    CSV
    assert_equal <<~CSV, exporter.to_csv(force_quotes: true)
      "1"
    CSV
    assert_equal <<~CSV, exporter.to_csv(force_quotes: false)
      1
    CSV
    Rexport.config.csv_default_force_quotes = false
    assert_equal <<~CSV, exporter.to_csv
      1
    CSV
    assert_equal <<~CSV, exporter.to_csv(force_quotes: true)
      "1"
    CSV
    assert_equal <<~CSV, exporter.to_csv(force_quotes: false)
      1
    CSV
  end

  test 'to_csv(row_sep)' do
    (1..2).each do |i|
      Sample.create!(integer: i)
    end
    exporter = IntegerExporter.new(Sample.all)
    # LF
    assert_equal <<~CSV, exporter.to_csv(row_sep: :auto)
      1
      2
    CSV
    assert_equal <<~CSV, exporter.to_csv(row_sep: "\n")
      1
      2
    CSV
    assert_equal <<~CSV, exporter.to_csv(row_sep: nil)
      1
      2
    CSV
    # CRLF
    assert_equal <<~CSV, exporter.to_csv(row_sep: "\r\n")
      1\r
      2\r
    CSV
    Rexport.config.csv_default_row_sep = "\r\n"
    assert_equal <<~CSV, exporter.to_csv
      1\r
      2\r
    CSV
  end

end
