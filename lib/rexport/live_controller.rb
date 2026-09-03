module Rexport
  class LiveController < ActionController::Base
    include ActionController::Live

    def initialize(exporter:, filename:, format:)
      super()
      @exporter = exporter
      @filename = "#{filename}.#{format}"
      @format = format
    end

    def export
      case @format
      when :csv
        send_csv
      when :xlsx
        send_xlsx
      end
    end

    private

      def send_csv
        send_stream filename: @filename do |stream|
          @exporter.each(format: :csv) do |data|
            stream.write data
          end
        end
      end

      def send_xlsx
        response.headers['Cache-Control'] = 'no-cache'
        response.headers['Last-Modified'] = Time.current.httpdate
        response.headers['X-Accel-Buffering'] = 'no'
        response.headers['Content-Encoding'] = 'identity'
        response.headers.delete('Content-Length')
        send_stream filename: @filename, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' do |stream|
          workbook = Xlsxtream::Workbook.new(stream)
          workbook.write_worksheet do |sheet|
            @exporter.each do |row|
              sheet << row
            end
          end
          workbook.close
        end
      end

  end

end
