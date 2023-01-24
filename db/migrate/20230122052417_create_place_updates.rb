class CreatePlaceUpdates < ActiveRecord::Migration[7.0]
  def change
    create_table :place_updates do |t|
      t.text :text
      t.references :place, null: false, foreign_key: true
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
