class AddPeopleNumberAproxToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :people_approx, :integer
  end
end
