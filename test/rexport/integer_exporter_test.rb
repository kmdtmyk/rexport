require "test_helper"

class Rexport::IntegerExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    (1..3).each do |i|
      Sample.create!(integer: i)
    end
    exporter = IntegerExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      1
      2
      3
    CSV
  end

end
