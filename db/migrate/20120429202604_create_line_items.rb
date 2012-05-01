class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :name
      t.float :fixed_amount
      t.integer :property_id
      t.integer :category

      t.timestamps
    end
  end
end
