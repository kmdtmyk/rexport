
class BookExporter < Rexport::Exporter

  def ids_to_a(ids)
    Book.find(ids).map do |book|
      [
        book.id,
        book.name,
        book.price,
        book.release_date,
        book.created_at,
        book.updated_at,
      ]
    end
  end

end
