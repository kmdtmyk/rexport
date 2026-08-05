module Rexport
  class Configuration

    attr_accessor :date_format
    attr_accessor :datetime_format
    attr_accessor :csv_default_encoding

    def initialize
      @csv_default_encoding = Encoding::UTF_8
    end

  end
end
