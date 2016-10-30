class AddScoreToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :score, :float, null: true
  end
end
