class AddFieldsToDocument < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :company_address, :string
    add_column :documents, :city, :string
    add_column :documents, :pincode, :string
    add_column :documents, :country, :string
  end
end
