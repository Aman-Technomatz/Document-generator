class AddAppointmentLetterFieldsToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :work_timings, :integer
    add_column :documents, :probation_period, :integer
    add_column :documents, :service_agreement, :integer
    add_column :documents, :annual_leave, :integer
    add_column :documents, :notice_period, :integer
  end
end
