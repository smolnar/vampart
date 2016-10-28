class AddModelToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :model, :float, null: true, array: true
  end
end
