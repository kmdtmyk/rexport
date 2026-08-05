require "test_helper"

class Rexport::FormatterTest < ActiveSupport::TestCase

  test 'format' do
    assert_equal '🍣', Rexport::Formatter.format('🍣', encoding: Encoding::UTF_8)
    assert_equal '?', Rexport::Formatter.format('🍣', encoding: Encoding::SJIS)
  end

end
