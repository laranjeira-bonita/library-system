class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :synopsis
      t.date :published_at
      t.references :author, null: false

      t.timestamps
    end
  end
end
