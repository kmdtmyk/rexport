module Rexport
  module Controller
    extend ActiveSupport::Concern

    class << self

      def live_controller_class
        @live_controller_class ||= Class.new(ActionController::Base) do
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

    end

    def send_export(exporter, filename:, format:)
      live_controller_class = Rexport::Controller.live_controller_class
      live_controller = live_controller_class.new(exporter: exporter, filename: filename, format: format)
      live_response = live_controller_class.make_response!(request)
      live_response.status = response.status
      live_response.headers.merge!(response.headers)

      live_controller.dispatch(:export, request, live_response)
      self.response = live_response
    end

  end

end
