class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.references :shop, index: true, foreign_key: true
      t.string :topic

      t.timestamps null: false
    end
  end
end
