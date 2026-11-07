require "test_helper"

class Rexport::ExporterTest < ActiveSupport::TestCase

  test 'to_csv(force_quotes)' do
    Sample.create!(integer: 1)
    exporter = IntegerExporter.new(Sample.all)
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

end
