class AddFieldsToDocumentsAndUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :end_position, :string
    add_column :documents, :start_position, :string
    add_column :documents, :start_date, :date
    add_column :documents, :end_date, :date
  end
end
