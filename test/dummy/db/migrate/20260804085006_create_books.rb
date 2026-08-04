class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, comment: 'タイトル'
      t.integer :price, comment: '価格'
      t.date :release_date, comment: '発売日'

      t.timestamps
    end

    create_table :samples do |t|
      t.string :string
      t.integer :integer
      t.date :date
      t.datetime :datetime
      t.timestamps
    end

  end
end
