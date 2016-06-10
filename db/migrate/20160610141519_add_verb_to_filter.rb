class AddVerbToFilter < ActiveRecord::Migration
  def change
    add_column :filters, :verb, :string, null: :false
  end
end
