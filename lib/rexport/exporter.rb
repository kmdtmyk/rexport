module Rexport
  class Exporter

    def initialize(records)
      @records = records
    end

    def to_csv(encoding: nil)
      result = ''

      encoding ||= Rexport.config.csv_default_encoding

      @records.ids.each_slice(1000).each_with_index do |ids, index|
        csv = CSV.generate(force_quotes: true) do |csv|

          if index == 0 && respond_to?(:headers)
            csv << headers.map{ self.class.encode(_1, encoding:) }
          end

          ids_to_a(ids).each do |row|
            csv << row.map{ self.class.encode(_1, encoding:) }
          end
        end

        result += csv
      end

      result
    end

    def ids_to_a(ids)
      raise "#{self.class} に #{__method__} の実装が必要です"
    end

    class << self

      def encode(value, encoding:)

        case value
        when Date
          value = I18n.l(value, format: Rexport.config.date_format)
        when Time
          value = I18n.l(value, format: Rexport.config.datetime_format)
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
