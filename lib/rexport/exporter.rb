module Rexport
  class Exporter

    def initialize(records)
      @records = records
    end

    def to_csv
      result = ''

      @records.ids.each_slice(1000).each_with_index do |ids, index|
        csv = CSV.generate(force_quotes: true) do |csv|

          if index == 0 && respond_to?(:headers)
            csv << headers
          end

          ids_to_a(ids).each do |row|
            csv << row
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

        if value.class == String && encoding.present?
          # 互換性のない文字を変換する(shift-jisだと絵文字が含まれているとエラーになる)
          value = value.encode(encoding, undef: :replace)
        end

        value
      end

    end

  end
end
