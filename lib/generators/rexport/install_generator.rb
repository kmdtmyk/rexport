module Rexport
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def install
        template 'rexport.rb.tt', 'config/initializers/rexport.rb'
      end

    end
  end
end
