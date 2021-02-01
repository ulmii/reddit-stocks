class CreateRedditStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :reddit_stocks do |t|
      t.string :symbol
      t.integer :count

      t.timestamps
    end
  end
end
