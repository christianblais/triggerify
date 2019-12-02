class AddVerbToFilter < ActiveRecord::Migration[5.0]
  def change
    add_column :filters, :verb, :string, null: :false
  end
end
