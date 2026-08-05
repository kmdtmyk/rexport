module Rexport
  class Exporter

    def initialize(records)
      @records = records
    end

    def each(batch_size: nil, format: nil)
      if format == :csv

        encoding ||= Rexport.config.csv_default_encoding

        @records.ids.each_slice(batch_size || 1000).each_with_index do |ids, index|
          csv_text = CSV.generate(force_quotes: true) do |csv|

            if index == 0 && respond_to?(:headers)
              csv << headers.map{ self.class.encode(_1, encoding:) }
            end

            ids_to_a(ids).each do |row|
              csv << row.map{ self.class.encode(_1, encoding:) }
            end
          end

          yield csv_text
        end

      else

        if respond_to?(:headers)
          yield headers.map{ self.class.encode(_1, encoding: nil) }
        end
        @records.ids.each_slice(batch_size || 1000) do |ids|
          ids_to_a(ids).each do |row|
            yield row.map{ self.class.encode(_1, encoding: nil) }
          end
        end

      end
    end

    def to_csv(encoding: nil, batch_size: nil, &block)
      result = ''

      encoding ||= Rexport.config.csv_default_encoding

      @records.ids.each_slice(batch_size || 1000).each_with_index do |ids, index|
        csv_text = CSV.generate(force_quotes: true) do |csv|

          if index == 0 && respond_to?(:headers)
            csv << headers.map{ self.class.encode(_1, encoding:) }
          end

          ids_to_a(ids).each do |row|
            csv << row.map{ self.class.encode(_1, encoding:) }
          end
        end

        # blockが渡された時は変数に保持しない
        if block_given?
          yield csv_text
        else
          result += csv_text
        end

      end

      if block_given?
        nil
      else
        result
      end
    end

    def ids_to_a(ids)
      raise "#{self.class} に #{__method__} の実装が必要です"
    end

    class << self

      def encode(value, encoding:)

        case value
        when Date
          if Rexport.config.date_format.present?
            value = I18n.l(value, format: Rexport.config.date_format)
          end
        when Time
          if Rexport.config.datetime_format.present?
            value = I18n.l(value, format: Rexport.config.datetime_format)
          end
        end

        if value.class == String && encoding.present?
          # 互換性のない文字を変換する(shift-jisだと絵文字が含まれているとエラーになる)
          value = value.encode(encoding, undef: :replace)
        end

        value
      end

    end

  end
end
