class AddApprovedToPlace < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :approved, :boolean, default: false, null: false
  end
end
