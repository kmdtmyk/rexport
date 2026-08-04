require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest

  test 'CSVをダウンロードできる' do
    Book.create!(title: 'Rails入門', price: 1000)
    get '/books.csv'
    assert_response :success
    assert_equal 'text/csv', response.media_type
    rows = CSV.parse(response.body, headers: true)
    assert_equal 1, rows.size
    assert_equal 'Rails入門', rows[0]['タイトル']
    assert_equal '1000', rows[0]['価格']
  end

end
