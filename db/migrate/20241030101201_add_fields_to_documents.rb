class AddFieldsToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :employee_id, :string
  end
end
