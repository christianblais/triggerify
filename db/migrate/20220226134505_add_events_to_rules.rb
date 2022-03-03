class AddEventsToRules < ActiveRecord::Migration[6.1]
  def change
    add_column :rules, :events, :json, null: false, default: []
  end
end
