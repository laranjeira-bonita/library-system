class AddPriceBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :price_per_day, :decimal, precision: 8, scale: 2, default: 0
  end
end
