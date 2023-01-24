class RemoveApprovedFromPlaceUpdates < ActiveRecord::Migration[7.0]
  def change
    remove_column :place_updates, :approved
  end
end
