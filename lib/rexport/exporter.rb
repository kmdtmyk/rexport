module Rexport
  class Exporter

    class_attribute :csv_encoding_setting, instance_accessor: false, default: nil
    private_class_method :csv_encoding_setting, :csv_encoding_setting=

    class_attribute :csv_force_quotes_setting, instance_accessor: false, default: nil
    private_class_method :csv_force_quotes_setting, :csv_force_quotes_setting=

    def self.csv_encoding(value)
      send(:csv_encoding_setting=, value)
    end

    def self.csv_force_quotes(value)
      send(:csv_force_quotes_setting=, value)
    end

    def initialize(records)
      @records = records
    end

    def each(batch_size: nil, format: nil, encoding: nil, force_quotes: nil, row_sep: nil)
      if format == :csv

        if force_quotes.nil?
          force_quotes = self.class.send(:csv_force_quotes_setting)
        end
        if force_quotes.nil?
          force_quotes = Rexport.config.csv_default_force_quotes
        end
        if encoding.nil?
          encoding = self.class.send(:csv_encoding_setting)
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
