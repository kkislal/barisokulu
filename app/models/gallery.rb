class Gallery < ApplicationRecord
  has_many_attached :images
  validates :title, presence: true
  validate :image_type

  private
  def image_type
    images.each do |image|
      if !image.content_type.in?(%('image/jpg image/jpeg image/png image/gif image/tif image/tiff'))
        errors.add(:images,"yüklenmeye çalışılan imaj tipi geçerli değil, jpg,gif,png veya tiff formatlı dosyalar sadece eklenebilir.")
    end
  end

  end
end
