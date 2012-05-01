class AddPeriodToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :period, :integer

  end
end
