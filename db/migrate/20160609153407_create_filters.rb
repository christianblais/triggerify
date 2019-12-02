class CreateFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :filters do |t|
      t.references :rule, index: true, foreign_key: true, null: false

      t.string :value, null: false
      t.string :regex, null: false

      t.timestamps null: false
    end
  end
end
