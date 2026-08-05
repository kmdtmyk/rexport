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

end
