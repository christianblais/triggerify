class CreateHandlers < ActiveRecord::Migration[5.0]
  def change
    create_table :handlers do |t|
      t.references :rule, index: true, foreign_key: true, null: false
      t.string :service_name, null: false
      t.text :settings, null: false

      t.timestamps null: false
    end
  end
end
