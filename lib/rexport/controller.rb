module Rexport
  module Controller

    def send_export(exporter, filename:, format:)
      live_controller = Rexport::LiveController.new(exporter: exporter, filename: filename, format: format)
      live_response = Rexport::LiveController.make_response!(request)
      live_response.status = response.status
      live_response.headers.merge!(response.headers)

      live_controller.dispatch(:export, request, live_response)
      self.response = live_response
    end

  end

end
