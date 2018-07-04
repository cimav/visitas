class AddCareerToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :career, :string
    add_column :visits, :reason, :text
    remove_column :visits, :notes
  end
end
