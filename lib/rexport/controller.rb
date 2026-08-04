module Rexport
  module Controller
    extend ActiveSupport::Concern

    included do

      def send_export(exporter, filename:, format:)
        send_stream filename: "#{filename}.#{format}" do |stream|
          exporter.to_csv do |data|
            stream.write data
          end
        end
      end

    end

  end
end
