class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :contact, foreign_key: true
      t.string :description, null: false

      t.timestamps
    end
  end
end
