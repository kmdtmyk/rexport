require "test_helper"

class Rexport::DatetimeExporterTest < ActiveSupport::TestCase

  teardown do
    Rexport.instance_variable_set(:@config, nil)
  end

  test 'to_csv' do
    Sample.create!(datetime: Time.new(2026, 8, 4, 12, 34, 56))
    exporter = DatetimeExporter.new(Sample.all)
    assert_equal exporter.to_csv, <<~CSV
      "2026/08/04 12:34:56"
    CSV

    Rexport.config.datetime_format = '%Y年%m月%d日 %H:%M'
    assert_equal exporter.to_csv, <<~CSV
      "2026年08月04日 12:34"
    CSV
  end

end
