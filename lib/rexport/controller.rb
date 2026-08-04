module Rexport
  module Controller
    extend ActiveSupport::Concern

    included do

      def send_export(exporter, filename:)

        send_stream filename: do |stream|
          exporter.to_csv do |data|
            stream.write data
          end
        end

      end

    end

  end
end
