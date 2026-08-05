require "test_helper"

class Rexport::BookExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    Book.create!(
      id: 1,
      title:  'book1',
      price: 100,
      release_date: Date.new(2026, 8, 6),
    )
    assert_equal <<~CSV, BookExporter.new(Book.all).to_csv
      "id","タイトル","価格","発売日"
      "1","book1","100","2026-08-06"
    CSV
  end

end
