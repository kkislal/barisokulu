class Post < ApplicationRecord
  belongs_to :user
  belongs_to :blog_category
  has_many :comments, as: :refmodel, :dependent => :delete_all
  has_many :tags, as: :refmodel, :dependent => :delete_all
  has_one_attached :img

  scope :scp_ordered_new, -> { order(created_at: :desc) }
  scope :scp_ordered_updated, -> { order(updated_at: :desc) }
  scope :scp_postOwner_menu, -> { joins("INNER JOIN users ON posts.user_id = users.id").select("users.id, users.name, count(posts.id) as post_count").group("users.id, users.name") }
  scope :scp_ordered_comments, -> { order("posts.comment_count desc") }
  scope :scp_published, ->  { where(status: :publish) }
  scope :scp_draft, ->  { where(status: :draft) }
  scope :scp_content?, ->(content) { where('posts.content like ? or posts.title like ? ', content,content) }
  scope :scp_category?, ->(cat_id) { where('posts.blog_category_id = ?', cat_id) }
  scope :scp_user?, ->(user_id) { where('posts.user_id = ?', user_id) }
  scope :scp_tag?, ->(tag) {includes(:user, :blog_category, :tags).references(:user, :blog_category, :tags).where("tags.tag = ?", tag)}

  def img_url
    if self.img.attached?
      self.img
    else
      "/images/post_default.jpg"
    end
  end

  def post_img_url
    if self.img.attached?
      self.img
    elsif self.blog_category.img.attached?
      self.blog_category.img
    else
      "/images/post_default.jpg"
    end
  end

end
