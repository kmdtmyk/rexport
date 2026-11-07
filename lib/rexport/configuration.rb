module Rexport
  class Configuration

    attr_accessor :date_format
    attr_accessor :datetime_format
    attr_accessor :csv_default_force_quotes
    attr_accessor :csv_default_row_sep
    attr_accessor :csv_default_encoding
    attr_accessor :csv_utf8_bom

    def initialize
      @csv_default_force_quotes = CSV::DEFAULT_OPTIONS[:force_quotes]
      @csv_default_row_sep = CSV::DEFAULT_OPTIONS[:row_sep]
      @csv_default_encoding = Encoding::UTF_8
      @csv_utf8_bom = true
    end

  end
end
