class AddFieldsToPayslip < ActiveRecord::Migration[7.1]
  def change
    add_column :payslips, :other_allowance, :decimal
  end
end
