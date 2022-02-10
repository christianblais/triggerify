class AddLastErrorsToHandlers < ActiveRecord::Migration[6.0]
  def change
    add_column :handlers, :last_errors, :text
  end
end
