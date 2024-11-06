class RemoveUnwantedFieldsFromDocument < ActiveRecord::Migration[7.1]
  def change
    remove_column :documents, :reason, :text
    remove_column :documents, :new_salary, :decimal
    remove_column :documents, :content, :text
    remove_column :documents, :last_working_day, :date
    remove_column :documents, :effective_date, :date
  end
end
