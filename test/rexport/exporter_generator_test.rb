require "test_helper"
require "rails/generators/test_case"
require "generators/rexport/exporter_generator"

class ExporterGeneratorTest < Rails::Generators::TestCase
  tests Rexport::Generators::ExporterGenerator

  destination File.expand_path("../tmp/generator", __dir__)

  setup :prepare_destination

  test "Book exporter を生成する" do
    run_generator ["book"]

    assert_file "app/exporters/book_exporter.rb" do |content|
      assert_includes content, "class BookExporter < Rexport::Exporter"
      assert_includes content, "'タイトル'"
      assert_includes content, "'価格'"
      assert_includes content, "'発売日'"
      assert_includes content, "Book.find(ids)"
      assert_includes content, "book.title"
      assert_includes content, "book.price"
      assert_includes content, "book.release_date"
    end
  end

  test "大文字" do
    run_generator ["Book"]

    assert_file "app/exporters/book_exporter.rb" do |content|
      assert_includes content, "class BookExporter < Rexport::Exporter"
    end
  end

end
