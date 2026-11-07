require "test_helper"

class Rexport::DecimalExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    Sample.create!(decimal: 1)
    exporter = DecimalExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      1.0
    CSV
  end

end
