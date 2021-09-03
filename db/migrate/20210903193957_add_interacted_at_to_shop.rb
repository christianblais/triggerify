class AddInteractedAtToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :interacted_at, :datetime, null: false, default: Time.at(0).utc
  end
end
