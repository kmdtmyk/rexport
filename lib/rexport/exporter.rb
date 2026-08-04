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

  end
end
