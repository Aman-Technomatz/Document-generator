class Document < ApplicationRecord
  belongs_to :user, optional: true
  accepts_nested_attributes_for :user

  scope :search_by_query, ->(query) {
    joins(:user).where(
      "documents.id LIKE :query OR documents.document_type LIKE :query OR documents.employee_id LIKE :query OR users.name LIKE :query OR users.id LIKE :query",
      query: "%#{query}%"
    )
  }

end
