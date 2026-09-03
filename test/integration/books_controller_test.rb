require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest

  test 'controllers do not include ActionController::Live' do
    assert_not_includes ApplicationController.ancestors, ActionController::Live
    assert_not_includes BooksController.ancestors, ActionController::Live

    live_controller_class = Rexport::Controller.live_controller_class
    assert_nil live_controller_class.name
    assert_includes live_controller_class.ancestors, ActionController::Live
  end

  test 'books.csv' do
    Rexport.config.csv_default_encoding = Encoding::UTF_8
    Rexport.config.csv_utf8_bom = false
    Book.create!(title: 'Rails入門', price: 1000)
    get '/books.csv'
    assert_response :success
    assert_equal 'text/csv', response.media_type
    assert_match /attachment/, response.headers['Content-Disposition']
    assert_match /books\.csv/, response.headers['Content-Disposition']
    assert_equal false, response.body.start_with?("\uFEFF")
    rows = CSV.parse(response.body, headers: true)
    assert_equal 1, rows.size
    assert_equal 'Rails入門', rows[0]['タイトル']
    assert_equal '1000', rows[0]['価格']
  end

  test 'books.csv(utf8 bom)' do
    Rexport.config.csv_default_encoding = Encoding::UTF_8
    Rexport.config.csv_utf8_bom = true
    Book.create!(title: 'Rails入門', price: 1000)
    get '/books.csv'
    assert_equal true, response.body.start_with?("\uFEFF")
    rows = CSV.read(StringIO.new(response.body), headers: true)
    assert_equal 1, rows.size
  end

  test 'books.xlsx' do
    Book.create!(title: 'Rails入門', price: 1000)
    get '/books.xlsx'
    assert_response :success
    assert_equal 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', response.media_type
    assert_match /books\.xlsx/, response.headers['Content-Disposition']
    assert response.body.present?
  end

end
