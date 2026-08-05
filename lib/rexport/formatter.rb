module Rexport
  module Formatter
    module_function

    def format(value, encoding:)

      case value
      when Date
        if Rexport.config.date_format.present?
          value = I18n.l(value, format: Rexport.config.date_format)
        end
      when Time
        if Rexport.config.datetime_format.present?
          value = I18n.l(value, format: Rexport.config.datetime_format)
        end
      end

      if value.class == String && encoding.present?
        # 互換性のない文字を変換する(shift-jisだと絵文字が含まれているとエラーになる)
        value = value.encode(encoding, undef: :replace)
      end

      value
    end

  end
end
