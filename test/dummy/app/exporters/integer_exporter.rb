class IntegerExporter < Rexport::Exporter

  def ids_to_a(ids)
    Sample.find(ids).map do |sample|
      [
        sample.integer,
      ]
    end
  end

end
