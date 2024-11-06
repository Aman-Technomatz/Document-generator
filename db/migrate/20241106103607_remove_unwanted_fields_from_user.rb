class RemoveUnwantedFieldsFromUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :position, :text
  end
end
