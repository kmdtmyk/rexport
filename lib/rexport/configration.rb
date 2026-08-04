module Rexport
  class Configuration

    attr_accessor :date_format
    attr_accessor :datetime_format

    def initialize
      @date_format = '%Y/%m/%d'
      @datetime_format = '%Y/%m/%d %H:%M:%S'
    end

  end
end
