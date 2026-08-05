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

end
