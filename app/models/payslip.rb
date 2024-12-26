class Payslip < ApplicationRecord
  belongs_to :document, optional: true
  has_one_attached :logo

  before_save :set_default_image

  private

  def set_default_image
    self.logo ||= "app/assets/images/logo.png"
  end

end
