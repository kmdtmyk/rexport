class BooleanExporter < Rexport::Exporter

  def ids_to_a(ids)
    Sample.find(ids).map do |sample|
      [
        sample.boolean,
      ]
    end
  end

end
