class AddAssistantToDepartmens < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :assistant_email, :string
  end
end
