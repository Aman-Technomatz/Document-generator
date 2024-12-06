class Payslip < ApplicationRecord
  belongs_to :document, optional: true
  has_one_attached :logo
end
