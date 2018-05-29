class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.references :department, foreign_key: false
      t.string :institution
      t.string :resp_name
      t.string :resp_phone
      t.string :notes
      t.string :resp_email
      t.integer :transport_type
      t.integer :status
      t.datetime :date

      t.timestamps
    end
  end
end
