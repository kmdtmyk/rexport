# Rexport
Short description and motivation.

## Installation

```ruby
gem 'rexport', git: 'https://github.com/kmdtmyk/rexport', ref: '<commit_hash>'
```

```bash
$ bundle install
```

## Usage

```bash
$ rails g rexport:install
```

```ruby
# config/initializers/rexport.rb

Rexport.config.date_format = '%Y/%m/%d'
Rexport.config.datetime_format = '%Y/%m/%d %H:%M:%S'
Rexport.config.csv_default_encoding = Encoding::UTF_8

```

```ruby
class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, comment: 'タイトル'
      t.integer :price, comment: '価格'
      t.date :release_date, comment: '発売日'
      t.timestamps
    end
  end
end
```

```bash
$ rails db:migrate
$ rails g rexport:exporter book
```

```ruby
# app/exporters/book_exporter.rb

class BookExporter < Rexport::Exporter

  def headers
    [
      'id',
      'タイトル',
      '価格',
      '発売日',
      'created_at',
      'updated_at',
    ]
  end

  def ids_to_a(ids)
    Book.find(ids).map do |book|
      [
        book.id,
        book.title,
        book.price,
        book.release_date,
        book.created_at,
        book.updated_at,
      ]
    end
  end

end
```

```ruby
class BooksController < ApplicationController

  def index
    @books = Book.all
    respond_to do |format|
      format.html
      format.csv{ send_export BookExporter.new(@books), filename: 'books', format: :csv }
      format.xlsx{ send_export BookExporter.new(@books), filename: 'books', format: :xlsx }
    end
  end

end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
