module Rexport
  class Exporter

    def initialize(records)
      @records = records
    end

    def each(batch_size: nil, format: nil, encoding: nil, force_quotes: nil, row_sep: nil)
      if format == :csv

        if force_quotes.nil?
          force_quotes = Rexport.config.csv_default_force_quotes
        end
        encoding ||= Rexport.config.csv_default_encoding
        row_sep ||= Rexport.config.csv_default_row_sep

        if (encoding == nil || encoding == Encoding::UTF_8) && Rexport.config.csv_utf8_bom == true
          yield "\uFEFF"
        end

        if respond_to?(:headers)
          yield CSV.generate_line(headers.map{ Rexport::Formatter.format(_1, encoding:) }, force_quotes:, row_sep:)
        end

        @records.ids.each_slice(batch_size || 1000).each_with_index do |ids, index|
          csv_text = CSV.generate(force_quotes:, row_sep:) do |csv|

            ids_to_a(ids).each do |row|
              csv << row.map{ Rexport::Formatter.format(_1, encoding:) }
            end
          end

          yield csv_text
        end

      else

        if respond_to?(:headers)
          yield headers.map{ Rexport::Formatter.format(_1, encoding: nil) }
        end
        @records.ids.each_slice(batch_size || 1000) do |ids|
          ids_to_a(ids).each do |row|
            yield row.map{ Rexport::Formatter.format(_1, encoding: nil) }
          end
        end

      end
    end

    def to_csv(encoding: nil, force_quotes: nil, row_sep: nil, batch_size: nil)
      # +'' で変更可能な文字列
      result = +''

      each(format: :csv, batch_size:, encoding:, force_quotes:, row_sep:) do |data|
        result << data
      end

      result
    end

    def ids_to_a(ids)
      raise NotImplementedError, "#{self.class} must implement the ##{__method__} method"
    end

  end
end
