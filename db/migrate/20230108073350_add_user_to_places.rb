class AddUserToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_reference :places, :user, foreign_key: true
  end
end
