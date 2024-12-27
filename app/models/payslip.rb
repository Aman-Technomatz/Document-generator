class Payslip < ApplicationRecord
  belongs_to :document, optional: true
  has_one_attached :logo

  before_save :set_default_image, if: -> { logo.blank? }
  attr_accessor :pay_slip_for_end_month

  private

  def set_default_image
    logo_path = Rails.root.join('app', 'assets', 'images', 'logo.png')

    if File.exist?(logo_path)
      self.logo.attach(io: File.open(logo_path), filename: 'logo.png', content_type: 'image/png')
    end
  end

end
