class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :serial_number
      t.integer :brand_id

      t.timestamps
    end
  end
end
