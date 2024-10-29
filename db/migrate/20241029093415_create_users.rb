class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :position
      t.integer :mobile_no

      t.timestamps
    end
  end
end
