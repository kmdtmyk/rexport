require "test_helper"

class Rexport::FormatterTest < ActiveSupport::TestCase

  test 'format' do
    assert_equal '🍣', Rexport::Formatter.format('🍣', encoding: Encoding::UTF_8)
    assert_equal '?', Rexport::Formatter.format('🍣', encoding: Encoding::SJIS)
  end

  test 'format ActiveSupport::TimeWithZone' do
    Rexport.config.datetime_format = '%Y年%m月%d日 %H:%M'
    assert_equal '2026年08月04日 12:34', Rexport::Formatter.format(ActiveSupport::TimeZone['UTC'].local(2026, 8, 4, 12, 34, 56), encoding: nil)
  end

end
