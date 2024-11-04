class Document < ApplicationRecord
  belongs_to :user, optional: true
  accepts_nested_attributes_for :user
end
