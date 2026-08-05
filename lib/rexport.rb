require "rexport/version"
require "rexport/railtie"
require "rexport/array_exporter"
require "rexport/configration"
require "rexport/controller"
require "rexport/exporter"
require "rexport/formatter"
require "csv"
require "xlsxtream"

module Rexport

  class << self

    def config
      @config ||= Rexport::Configuration.new
    end

  end

end
