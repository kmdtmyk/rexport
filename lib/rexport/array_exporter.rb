module Rexport
  class ArrayExporter

    def initialize(array)
      @array = array
    end

    def each(format: nil, encoding: nil)
      if format == :csv

        encoding ||= Rexport.config.csv_default_encoding

        if (encoding == nil || encoding == Encoding::UTF_8) && Rexport.config.csv_utf8_bom == true
          yield "\uFEFF"
        end

        csv_text = CSV.generate(force_quotes: true) do |csv|
          if respond_to?(:headers)
            csv << headers.map{ Rexport::Formatter.format(_1, encoding:) }
          end
          @array.each do |row|
            csv << row.map{ Rexport::Formatter.format(_1, encoding:) }
          end
        end

        yield csv_text

      else

        if respond_to?(:headers)
          yield headers.map{ Rexport::Formatter.format(_1, encoding: nil) }
        end
        @array.each do |row|
          yield row.map{ Rexport::Formatter.format(_1, encoding: nil) }
        end

      end
    end

    def to_csv(encoding: nil)
      # +'' で変更可能な文字列
      result = +''

      each(format: :csv, encoding:) do |data|
        result << data
      end

      result
    end

  end
end
