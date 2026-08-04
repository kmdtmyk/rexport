require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest

  test 'books.csv' do
    Book.create!(title: 'Rails入門', price: 1000)
    get '/books.csv'
    assert_response :success
    assert_equal 'text/csv', response.media_type
    assert_match /attachment/, response.headers['Content-Disposition']
    assert_match /books\.csv/, response.headers['Content-Disposition']
    rows = CSV.parse(response.body, headers: true)
    assert_equal 1, rows.size
    assert_equal 'Rails入門', rows[0]['タイトル']
    assert_equal '1000', rows[0]['価格']
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
