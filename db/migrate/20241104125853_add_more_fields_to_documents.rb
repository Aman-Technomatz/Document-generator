class AddMoreFieldsToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :ctc, :decimal
    add_column :documents, :experience_years, :integer
    add_column :documents, :current_salary, :decimal
    add_column :documents, :last_working_day, :date
    add_column :documents, :effective_date, :date
    add_column :documents, :new_salary, :decimal
    add_column :documents, :reason, :text
    add_column :documents, :gratitude, :text
  end
end
