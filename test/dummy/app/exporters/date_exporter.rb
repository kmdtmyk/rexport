class DateExporter < Rexport::Exporter

  def ids_to_a(ids)
    Sample.find(ids).map do |sample|
      [
        sample.date,
      ]
    end
  end

end
