require "test_helper"

class Rexport::DatetimeExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    sample = Sample.create!(datetime: Time.new(2026, 8, 4, 12, 34, 56))
    exporter = DatetimeExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      "2026-08-04 12:34:56 UTC"
    CSV

    Rexport.config.datetime_format = '%Y年%m月%d日 %H:%M'
    assert_equal <<~CSV, exporter.to_csv
      "2026年08月04日 12:34"
    CSV
  end

end
