require "rexport/version"
require "rexport/railtie"
require "rexport/configration"
require "rexport/controller"
require "rexport/exporter"
require "csv"

module Rexport

  class << self

    def config
      @config ||= Rexport::Configuration.new
    end

  end

end
