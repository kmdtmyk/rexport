require "test_helper"

class Rexport::StringExporterTest < ActiveSupport::TestCase

  teardown do
    Rexport.instance_variable_set(:@config, nil)
  end

  test 'to_csv' do
    Sample.create!(string: 'abc日本語🍣')
    exporter = StringExporter.new(Sample.all)
    assert_equal exporter.to_csv, <<~CSV
      "abc日本語🍣"
    CSV

    assert_equal exporter.to_csv(encoding: Encoding::SJIS), <<~CSV.encode(Encoding::SJIS)
      "abc日本語?"
    CSV

    Rexport.config.csv_default_encoding = Encoding::SJIS
    assert_equal exporter.to_csv, <<~CSV.encode(Encoding::SJIS)
      "abc日本語?"
    CSV
  end

end
