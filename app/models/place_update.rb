class PlaceUpdate < ApplicationRecord
  belongs_to :place

  def self.needs_review
    where("updated_at > created_at")
  end

  def self.clear_old!
    where("updated_at = created_at").where("created_at < ?", 2.days.ago).destroy_all
  end

  def merge_with_place
    unneeded_attributes = (attributes.keys - place.attributes.keys) + %w[created_at updated_at id]
    new_attributes = attributes
    unneeded_attributes.each { |a| new_attributes.delete a }
    place.update(new_attributes)
    destroy!
  end
end
