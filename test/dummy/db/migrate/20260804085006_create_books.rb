class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :name, comment: '名前'
      t.integer :price, comment: '価格'
      t.date :release_date, comment: '発売日'

      t.timestamps
    end

    create_table :samples do |t|
      t.date :date
      t.datetime :datetime
      t.timestamps
    end

  end
end
