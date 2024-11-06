class RenameTitleToOrganizationName < ActiveRecord::Migration[7.1]
  def change
    rename_column :documents, :title, :organization_name
  end
end
