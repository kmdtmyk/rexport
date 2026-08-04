require "test_helper"

class Rexport::BookExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    Book.create!(
      id: 1,
      name: 'book1',
      price: 100,
      release_date: Date.new(2026, 8, 6),
      created_at: Time.new(2026, 8, 1, 2, 3, 4),
      updated_at: Time.new(2026, 8, 9, 8, 7, 6),
    )
    assert_equal BookExporter.new(Book.all).to_csv, <<~CSV
      "id","名前","価格","発売日","created_at","updated_at"
      "1","book1","100","2026/08/06","2026/08/01 02:03:04","2026/08/09 08:07:06"
    CSV
  end

  test 'to_csv(shift-jis)' do
    Book.create!(
      id: 1,
      name: '🍣',
      price: 100,
      release_date: Date.new(2026, 8, 6),
      created_at: Time.new(2026, 8, 1, 2, 3, 4),
      updated_at: Time.new(2026, 8, 9, 8, 7, 6),
    )
    assert_equal BookExporter.new(Book.all).to_csv(encoding: Encoding::SJIS), <<~CSV.encode(Encoding::SJIS)
      "id","名前","価格","発売日","created_at","updated_at"
      "1","?","100","2026/08/06","2026/08/01 02:03:04","2026/08/09 08:07:06"
    CSV
  end

end
