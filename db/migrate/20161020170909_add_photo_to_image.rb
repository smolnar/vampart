class AddPhotoToImage < ActiveRecord::Migration[5.0]
  def up
    add_attachment :images, :photo
  end

  def down
    remove_attachment :images, :photo
  end
end
