module Rexport
  module Controller

    extend ActiveSupport::Concern

    included do

      def send_export(exporter, filename:)
        send_data exporter.to_csv, filename:
      end

    end

  end
end
