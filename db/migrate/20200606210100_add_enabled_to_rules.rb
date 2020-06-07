class AddEnabledToRules < ActiveRecord::Migration[5.2]
  def change
    add_column(:rules, :enabled, :boolean, default: true)

    # Might be a PG bug, can't add null on the add_column statement
    change_column(:rules, :enabled, :boolean, null: false)
  end
end
