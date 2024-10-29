class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.string :document_type
      t.string :remark

      t.timestamps
    end
  end
end
