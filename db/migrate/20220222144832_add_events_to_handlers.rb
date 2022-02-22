class AddEventsToHandlers < ActiveRecord::Migration[6.1]
  def change
    add_column :handlers, :events, :text
  end
end
