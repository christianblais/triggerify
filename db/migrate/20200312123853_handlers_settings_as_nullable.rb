class HandlersSettingsAsNullable < ActiveRecord::Migration[5.2]
  def up
    # https://edgeapi.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization/ClassMethods.html#method-i-serialize
    # Empty objects as {}, in the case of Hash, or [], in the case of Array, will always be persisted as null.
    #
    # We still need to figure out the validation layer, but this change makes it align with the expected rails behaviour of `serialize`
    change_column :handlers, :settings, :text, null: true
  end

  def down
    change_column :handlers, :settings, :text, null: false
  end
end
