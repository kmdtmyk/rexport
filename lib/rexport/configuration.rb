module Rexport
  class Configuration

    attr_accessor :date_format
    attr_accessor :datetime_format
    attr_accessor :csv_default_encoding
    attr_accessor :csv_utf8_bom

    def initialize
      @csv_default_encoding = Encoding::UTF_8
      @csv_utf8_bom = true
    end

  end
end
