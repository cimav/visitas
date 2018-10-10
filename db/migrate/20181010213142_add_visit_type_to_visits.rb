class AddVisitTypeToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :visit_type, :integer
  end
end
