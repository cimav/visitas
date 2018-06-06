class CreateVisitFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_files do |t|
      t.references :visit, foreign_key: true
      t.string :name
      t.string :file
      t.integer :file_type

      t.timestamps
    end
  end
end
