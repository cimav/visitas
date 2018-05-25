class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.references :departamento, foreign_key: false
      t.references :institution, foreign_key: false
      t.string :resp_name
      t.string :resp_phone
      t.string :resp_email
      t.datetime :requested_date
      t.integer :transport_type
      t.datetime :date

      t.timestamps
    end
  end
end
