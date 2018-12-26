class Tag < ApplicationRecord

  scope :scp_event_tags, -> { select(:tag).where("refmodel_type = 'Event'").distinct }
  scope :scp_post_tags, -> { select(:tag).where("refmodel_type = 'Post'").distinct }

end
