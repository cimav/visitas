class CreateVisitPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_people do |t|
      t.references :visit, foreign_key: true
      t.string :name
      t.integer :person_type
      t.datetime :check_in
      t.datetime :check_out

      t.timestamps
    end
  end
end
