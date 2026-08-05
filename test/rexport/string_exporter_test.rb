require "test_helper"

class Rexport::StringExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    Sample.create!(string: 'abc日本語🍣')
    exporter = StringExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      "abc日本語🍣"
    CSV

    assert_equal <<~CSV.encode(Encoding::SJIS), exporter.to_csv(encoding: Encoding::SJIS)
      "abc日本語?"
    CSV

    Rexport.config.csv_default_encoding = Encoding::SJIS
    assert_equal <<~CSV.encode(Encoding::SJIS), exporter.to_csv
      "abc日本語?"
    CSV
  end

  test 'to_csv(utf8bom)' do
    Rexport.config.csv_default_encoding = Encoding::UTF_8
    Rexport.config.csv_utf8_bom = false
    Sample.create!(string: 'abc日本語🍣')
    exporter = StringExporter.new(Sample.all)
    assert_equal false, exporter.to_csv.start_with?("\uFEFF")
    Rexport.config.csv_utf8_bom = true
    assert_equal true, exporter.to_csv.start_with?("\uFEFF")
  end

end
