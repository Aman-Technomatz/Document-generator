class AddHrNameFieldToDocument < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :hr_name, :string
  end
end
