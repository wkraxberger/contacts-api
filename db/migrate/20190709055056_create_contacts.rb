class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :cell_phone, null: false
      t.integer :zip_code, null: false

      t.timestamps
    end
  end
end
