class RemoveEmailFromDepartments < ActiveRecord::Migration[5.2]
  def change
    remove_column :departments, :assistant_email
  end
end
