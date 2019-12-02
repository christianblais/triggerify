class CreateRules < ActiveRecord::Migration[5.0]
  def change
    create_table :rules do |t|
      t.string :name, null: false
      t.references :shop, index: true, foreign_key: true, null: false
      t.string :topic, null: false

      t.timestamps null: false
    end
  end
end
