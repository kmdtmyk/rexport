module Rexport
  module Generators
    class ExporterGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def generate
        template 'exporter.rb.tt', "app/exporters/#{name}_exporter.rb"
      end

      private

        def model_class
          @model_class ||= class_name.constantize
        end

        def column_names
          model_class.column_names
        end

    end
  end
end
