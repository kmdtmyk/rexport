require "test_helper"

class BooksExportTest < ActionDispatch::IntegrationTest

  test 'CSVをダウンロードできる' do

    Book.create!(title: 'Rails入門', price: 1000)
    get '/books.csv'
    assert_response :success
    assert_equal response.media_type, 'text/csv'
    rows = CSV.parse(response.body, headers: true)
    assert_equal rows.size, 1
    assert_equal rows[0]['タイトル'], 'Rails入門'
    assert_equal rows[0]['価格'], '1000'
  end

end
