class BlogCategory < ApplicationRecord
  has_many :posts
  has_one_attached :img

  scope :scp_category_menu, -> { joins("INNER JOIN posts ON blog_categories.id = posts.blog_category_id").select("blog_categories.id, blog_categories.name, count(posts.id) as cat_count").group("blog_categories.id,blog_categories.name") }

  def img_url
    if self.img.attached?
      self.img
    else
      ""
    end
  end
end
