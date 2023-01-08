class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.text :text, null: false
      t.integer :rating, null: false, default: 4
      t.datetime :time, null: false
      t.string :language, null: false

      t.timestamps
    end
  end
end
