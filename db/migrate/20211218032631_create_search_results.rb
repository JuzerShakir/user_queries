class CreateSearchResults < ActiveRecord::Migration[5.2]
  def change
    create_table :search_results do |t|
      t.references :user, foreign_key: true
      t.string :keyword
      t.integer :adwords_count
      t.integer :links_count
      t.string :results_count
      t.text :html_code

      t.timestamps
    end
  end
end
