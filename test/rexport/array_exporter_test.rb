require "test_helper"

class Rexport::ArrayExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    array = [
      ['id', 'name', 'date'],
      [1, 'foo', Date.new(2026, 8, 5)],
    ]
    exporter = Rexport::ArrayExporter.new(array)
    assert_equal <<~CSV, exporter.to_csv
      "id","name","date"
      "1","foo","2026-08-05"
    CSV

    Rexport.config.date_format = '%Y年%m月%d日'
    assert_equal <<~CSV, exporter.to_csv
      "id","name","date"
      "1","foo","2026年08月05日"
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
      "abc日本語?"
    CSV
  end

end
