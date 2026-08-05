class BookExporter < Rexport::Exporter

  def headers
    [
      'id',
      'タイトル',
      '価格',
      '発売日',
    ]
  end

  def ids_to_a(ids)
    Book.find(ids).map do |book|
      [
        book.id,
        book.title,
        book.price,
        book.release_date,
      ]
    end
  end

end
