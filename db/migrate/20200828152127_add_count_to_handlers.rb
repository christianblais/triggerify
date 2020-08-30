class AddCountToHandlers < ActiveRecord::Migration[6.0]
  def change
    add_column :handlers, :handle_count, :integer, null: false, default: 0
  end
end
