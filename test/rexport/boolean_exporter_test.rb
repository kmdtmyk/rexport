require "test_helper"

class Rexport::BooleanExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    Sample.create!(boolean: true)
    Sample.create!(boolean: false)
    exporter = BooleanExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      true
      false
    CSV
  end

end
