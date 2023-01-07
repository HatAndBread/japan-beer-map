class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.decimal :lng, precision: 10, scale: 6
      t.decimal :lat, precision: 10, scale: 6
      t.string :website
      t.string :google_maps_url
      t.jsonb :periods
      t.string :name, null: false
      t.string :address
      t.string :phone
      t.string :google_place_id
      t.boolean :is_restaurant
      t.boolean :has_food
      t.boolean :is_shop
      t.boolean :is_bar
      t.jsonb :google_photos, default: [], null: false
      t.boolean :is_brewery

      t.timestamps
    end
  end
end
