class DatetimeExporter < Rexport::Exporter

  def ids_to_a(ids)
    Sample.find(ids).map do |sample|
      [
        sample.datetime,
      ]
    end
  end

end
