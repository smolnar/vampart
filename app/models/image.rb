class Image < ApplicationRecord
  has_attached_file :photo, styles: { processed: ["800x800>",:jpg] }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  validates :photo, attachment_presence: true

  def relative_path
    photo.path(:processed).gsub("#{Rails.root}/", '')
  end

  def faces
    @symbolized_faces ||= read_attribute(:faces).map(&:deep_symbolize_keys)
  end

  def processed_photo_url
    photo.url(:processed)
  end
end
