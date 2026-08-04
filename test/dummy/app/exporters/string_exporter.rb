class StringExporter < Rexport::Exporter

  def ids_to_a(ids)
    Sample.find(ids).map do |sample|
      [
        sample.string,
      ]
    end
  end

end
