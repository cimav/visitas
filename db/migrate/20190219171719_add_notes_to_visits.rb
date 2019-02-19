class AddNotesToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :notes, :text
  end
end
