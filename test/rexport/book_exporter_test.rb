require "test_helper"

class Rexport::BookExporterTest < ActiveSupport::TestCase

  test 'to_csv' do
    Book.create!(name: 'book1', price: 100, release_date: Date.new(2026, 8, 6))
    assert_equal BookExporter.new(Book.all).to_csv, <<~CSV
      "id","name","price","release_date"
      "1","book1","100","2026-08-06"
    CSV
  end

end
