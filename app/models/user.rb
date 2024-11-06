class User < ApplicationRecord
  has_many :documents
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

end
