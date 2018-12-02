class User < ApplicationRecord
  has_many :comments, :dependent => :delete_all
  has_one_attached :img

  has_secure_password

  def img_url
    if self.img.attached?
      self.img
    else
      "/images/default-avatar.png"
    end
  end

end
