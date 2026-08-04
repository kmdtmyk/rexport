module Rexport
  class Railtie < ::Rails::Railtie

    initializer 'rexport.controller' do
      ActiveSupport.on_load(:action_controller) do
        include ActionController::Live
        include Rexport::Controller
      end
    end

  end
end
