class AddStuffToPlaceUpdates < ActiveRecord::Migration[7.0]
  def change
    add_column :place_updates, :website, :string
    add_column :place_updates, :periods, :jsonb
    add_column :place_updates, :name, :string
    add_column :place_updates, :address, :string
    add_column :place_updates, :phone, :string
    add_column :place_updates, :has_food, :string
    add_column :place_updates, :is_shop, :string
    add_column :place_updates, :is_brewery, :string
  end
end
