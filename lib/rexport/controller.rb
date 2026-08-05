module Rexport
  module Controller
    extend ActiveSupport::Concern

    included do

      def send_export(exporter, filename:, format:)
        filename = "#{filename}.#{format}"

        case format
        when :csv
          send_stream filename: do |stream|
            exporter.each(format: :csv) do |data|
              stream.write data
            end
          end
        when :xlsx
          response.headers['Cache-Control'] = 'no-cache'
          response.headers['Last-Modified'] = Time.current.httpdate
          response.headers['X-Accel-Buffering'] = 'no'
          response.headers['Content-Encoding'] = 'identity'
          response.headers.delete('Content-Length')
          send_stream filename:, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' do |stream|
            workbook = Xlsxtream::Workbook.new(stream)
            workbook.write_worksheet do |sheet|
              exporter.each do |row|
                sheet << row
              end
            end
            workbook.close
          end
        end
      end

    end

  end
end
