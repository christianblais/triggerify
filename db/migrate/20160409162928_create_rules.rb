class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.references :shop, index: true, foreign_key: true, null: false
      t.string :topic, null: false

      t.timestamps null: false
    end
  end
end
