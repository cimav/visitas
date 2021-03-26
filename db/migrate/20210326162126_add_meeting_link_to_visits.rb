class AddMeetingLinkToVisits < ActiveRecord::Migration[5.2]
  def change
  	add_column :visits, :meeting_link, :string
  end
end
