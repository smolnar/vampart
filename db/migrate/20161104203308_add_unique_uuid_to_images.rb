class AddUniqueUuidToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :uid, :string, null: false, length: 64
    add_index :images, :uid, unique: true
  end
end
