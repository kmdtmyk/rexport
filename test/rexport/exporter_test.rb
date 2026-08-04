require "test_helper"

class Rexport::ExporterTest < ActiveSupport::TestCase

  test 'encode' do
    assert_equal '🍣', Rexport::Exporter.encode('🍣', encoding: Encoding::UTF_8)
    assert_equal '?', Rexport::Exporter.encode('🍣', encoding: Encoding::SJIS)
  end

end
