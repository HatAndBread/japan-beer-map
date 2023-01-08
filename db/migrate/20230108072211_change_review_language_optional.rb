class ChangeReviewLanguageOptional < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :language, :string, null: true
  end
end
