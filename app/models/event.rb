class Event < ApplicationRecord
  belongs_to :user
  belongs_to :event_category
  belongs_to :event_type
  has_many :comments, as: :refmodel, :dependent => :delete_all
  has_many :tags, as: :refmodel, :dependent => :delete_all
  has_one_attached :img

  scope :scp_ordered_new, -> { order(created_at: :desc) }
  scope :scp_ordered_updated, -> { order(updated_at: :desc) }
  scope :scp_postOwner_menu, -> { joins("INNER JOIN users ON events.user_id = users.id").select("users.id, users.name, count(events.id) as event_count").group("users.id, users.name") }
  scope :scp_ordered_comments, -> { order("events.comment_count desc") }
  scope :scp_published, ->  { where(status: :publish) }
  scope :scp_draft, ->  { where(status: :draft) }
  scope :scp_content?, ->(content) { where('events.content like ? or events.title like ? ', content,content) }
  scope :scp_category?, ->(cat_id) { where('events.event_category_id = ?', cat_id) }
  scope :scp_user?, ->(user_id) { where('events.user_id = ?', user_id) }
  scope :scp_tag?, ->(tag) {includes(:user, :event_category, :tags).references(:user, :event_category, :tags).where("tags.tag = ?", tag)}
  scope :scp_current_events, -> { where('(event_type_id=1 and end_date > current_timestamp()) or (event_type_id<>1 and start_date > current_timestamp())') }
  scope :scp_old_events, -> { where('end_date < current_timestamp()') }

  def img_url
    if self.img.attached?
      self.img
    else
      "/images/event_default.jpg"
    end
  end

  def event_img_url
    if self.img.attached?
      self.img
    elsif self.event_category.img.attached?
      self.event_category.img
    else
      "/images/event_default.jpg"
    end
  end

end
