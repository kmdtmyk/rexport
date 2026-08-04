module Rexport
  class Configuration

    attr_accessor :date_format
    attr_accessor :datetime_format
    attr_accessor :csv_default_encoding

    def initialize
      @date_format = '%Y/%m/%d'
      @datetime_format = '%Y/%m/%d %H:%M:%S'
      @csv_default_encoding = Encoding::UTF_8
    end

  end
end
