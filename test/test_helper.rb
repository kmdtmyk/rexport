# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [ File.expand_path("fixtures", __dir__) ]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase

  def before_setup
    super
    # テストではテストコードを書きやすい設定をデフォルトとする
    Rexport.config.date_format = nil
    Rexport.config.datetime_format = nil
    Rexport.config.csv_default_force_quotes = false
    Rexport.config.csv_default_row_sep = :auto
    Rexport.config.csv_default_encoding = Encoding::UTF_8
    Rexport.config.csv_utf8_bom = false
  end

  def after_teardown
    Rexport.instance_variable_set(:@config, nil)
    super
  end

end
