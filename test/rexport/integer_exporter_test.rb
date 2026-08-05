require "test_helper"

class Rexport::IntegerExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    (1..3).each do |i|
      Sample.create!(integer: i)
    end
    exporter = IntegerExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      "1"
      "2"
      "3"
    CSV
  end

  test 'each' do
    (1..3).each do |i|
      Sample.create!(integer: i)
    end

    exporter = IntegerExporter.new(Sample.all)

    result = []
    exporter.each do |data|
      result << data
    end
    assert_equal [
      [1], [2], [3],
    ], result

    result = []
    exporter.each(batch_size: 2, format: :csv) do |data|
      result << data
    end
    assert_equal [
      "\"1\"\n\"2\"\n",
      "\"3\"\n"
    ], result
  end

end
