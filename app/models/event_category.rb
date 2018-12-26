class EventCategory < ApplicationRecord
  has_many :events
  has_one_attached :img

  scope :scp_category_menu, -> { joins("INNER JOIN events ON event_categories.id = events.event_category_id").select("event_categories.id, event_categories.name, count(events.id) as cat_count").group("event_categories.id,event_categories.name") }

  def img_url
    if self.img.attached?
      self.img
    else
      ""
    end
  end
end
