require "test_helper"

class Rexport::IntegerExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    (1..3).each do |i|
      Sample.create!(integer: i)
    end
    exporter = IntegerExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      "1"
      "2"
      "3"
    CSV
  end

  test 'to_csv(row_sep)' do
    (1..2).each do |i|
      Sample.create!(integer: i)
    end
    exporter = IntegerExporter.new(Sample.all)
    # LF
    assert_equal <<~CSV, exporter.to_csv(row_sep: :auto)
      "1"
      "2"
    CSV
    assert_equal <<~CSV, exporter.to_csv(row_sep: "\n")
      "1"
      "2"
    CSV
    assert_equal <<~CSV, exporter.to_csv(row_sep: nil)
      "1"
      "2"
    CSV
    # CRLF
    assert_equal <<~CSV, exporter.to_csv(row_sep: "\r\n")
      "1"\r
      "2"\r
    CSV
    Rexport.config.csv_default_row_sep = "\r\n"
    assert_equal <<~CSV, exporter.to_csv
      "1"\r
      "2"\r
    CSV
  end

  test 'each' do
    (1..3).each do |i|
      Sample.create!(integer: i)
    end

    exporter = IntegerExporter.new(Sample.all)

    result = []
    exporter.each do |data|
      result << data
    end
    assert_equal [
      [1], [2], [3],
    ], result

    result = []
    exporter.each(batch_size: 2, format: :csv) do |data|
      result << data
    end
    assert_equal [
      "\"1\"\n\"2\"\n",
      "\"3\"\n"
    ], result
  end

end
