class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :street_address
      t.string :street_address2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :proptype
      t.float :depreciable_value

      t.timestamps
    end
  end
end
