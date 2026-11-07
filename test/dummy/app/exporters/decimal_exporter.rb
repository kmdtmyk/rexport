class DecimalExporter < Rexport::Exporter

  def ids_to_a(ids)
    Sample.find(ids).map do |sample|
      [
        sample.decimal,
      ]
    end
  end

end
