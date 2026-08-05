require "test_helper"

class Rexport::DateExporterTest < ActiveSupport::TestCase

  teardown do
    Rexport.instance_variable_set(:@config, nil)
  end

  test 'to_csv' do
    Sample.create!(date: Date.new(2026, 8, 4))
    exporter = DateExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      "2026-08-04"
    CSV

    Rexport.config.date_format = '%Y年%m月%d日'
    assert_equal <<~CSV, exporter.to_csv
      "2026年08月04日"
    CSV
  end

end
