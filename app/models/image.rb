class Image < ApplicationRecord
  has_attached_file :photo, styles: { processed: ["800x800>",:jpg] }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  validates :photo, attachment_presence: true
end
