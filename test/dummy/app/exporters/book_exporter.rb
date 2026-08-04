class BookExporter < Rexport::Exporter

  def headers
    [
      'id',
      'name',
      'price',
      'release_date',
    ]
  end

  def ids_to_a(ids)
    Book.find(ids).map do |book|
      [
        book.id,
        book.name,
        book.price,
        book.release_date,
      ]
    end
  end

end
