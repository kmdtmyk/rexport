require "test_helper"

class Rexport::ArrayExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    array = [
      ['id', 'name', 'date'],
      [1, 'foo', Date.new(2026, 8, 5)],
    ]
    exporter = Rexport::ArrayExporter.new(array)
    assert_equal <<~CSV, exporter.to_csv
      id,name,date
      1,foo,2026-08-05
    CSV

    Rexport.config.date_format = '%Y年%m月%d日'
    assert_equal <<~CSV, exporter.to_csv
      id,name,date
      1,foo,2026年08月05日
    CSV
  end

  test 'to_csv(force_quotes)' do
    array = [
      ['1'],
    ]
    exporter = Rexport::ArrayExporter.new(array)
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
    array = [
      ['id'],
      [1],
    ]
    exporter = Rexport::ArrayExporter.new(array)
    # LF
    assert_equal <<~CSV, exporter.to_csv(row_sep: :auto)
      id
      1
    CSV
    assert_equal <<~CSV, exporter.to_csv(row_sep: "\n")
      id
      1
    CSV
    assert_equal <<~CSV, exporter.to_csv(row_sep: nil)
      id
      1
    CSV
    # CRLF
    assert_equal <<~CSV, exporter.to_csv(row_sep: "\r\n")
      id\r
      1\r
    CSV
    Rexport.config.csv_default_row_sep = "\r\n"
    assert_equal <<~CSV, exporter.to_csv
      id\r
      1\r
    CSV
  end

  test 'to_csv(utf8bom)' do
    Rexport.config.csv_default_encoding = Encoding::UTF_8
    Rexport.config.csv_utf8_bom = false
    array = [
      ['abc日本語🍣'],
    ]
    exporter = Rexport::ArrayExporter.new(array)
    assert_equal false, exporter.to_csv.start_with?("\uFEFF")
    Rexport.config.csv_utf8_bom = true
    assert_equal true, exporter.to_csv.start_with?("\uFEFF")
  end

  test 'to_csv(shift-jis)' do
    Rexport.config.csv_default_encoding = Encoding::SJIS
    array = [
      ['abc日本語🍣'],
    ]
    exporter = Rexport::ArrayExporter.new(array)
    assert_equal <<~CSV.encode(Encoding::SJIS), exporter.to_csv
      abc日本語?
    CSV
  end

end
