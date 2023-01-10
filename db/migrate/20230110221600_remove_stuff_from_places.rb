class RemoveStuffFromPlaces < ActiveRecord::Migration[7.0]
  def change
    change_table(:places) do |t|
      t.remove :is_bar
      t.remove :is_restaurant
    end
  end
end
