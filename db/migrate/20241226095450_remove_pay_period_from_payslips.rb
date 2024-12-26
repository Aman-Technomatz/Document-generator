class RemovePayPeriodFromPayslips < ActiveRecord::Migration[7.1]
  def change
    remove_column :payslips, :pay_period, :string
  end
end
