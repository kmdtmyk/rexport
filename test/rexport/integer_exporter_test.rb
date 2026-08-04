require "test_helper"

class Rexport::IntegerExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    (1..5).each do |i|
      Sample.create!(integer: i)
    end

    exporter = IntegerExporter.new(Sample.all)
    assert_equal <<~CSV, exporter.to_csv
      "1"
      "2"
      "3"
      "4"
      "5"
    CSV

    result = []
    exporter.to_csv(batch_size: 3) do |data|
      result << data
    end
    assert_equal [
      "\"1\"\n\"2\"\n\"3\"\n",
      "\"4\"\n\"5\"\n"
    ], result

    # ブロックが渡された時は返り値なしにする
    assert_nil exporter.to_csv{}
  end

end
