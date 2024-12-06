class CreatePayslips < ActiveRecord::Migration[7.1]
  def change
    create_table :payslips do |t|
      t.date :pay_period
      t.integer :paid_days
      t.integer :loss_of_pay_days
      t.date :pay_date
      t.decimal :basic_salary
      t.decimal :income_tax
      t.decimal :house_rent_allowance
      t.decimal :provident_fund
      t.decimal :gross_earnings
      t.decimal :total_deductions
      t.decimal :total_net_payable
      t.date :pay_slip_for_month
      t.references :document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
