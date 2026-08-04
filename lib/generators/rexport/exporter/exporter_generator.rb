module Rexport
  module Generators
    class ExporterGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def generate
        template 'exporter.rb.tt', "app/exporters/#{name}_exporter.rb"
      end

    end
  end
end
