class AddEventsToRules < ActiveRecord::Migration[6.1]
  def change
    add_column :rules, :events, :text
  end
end
