class AddBetreuerinnenToEventCourseRecords < ActiveRecord::Migration[4.2]
  def change
    add_column :event_course_records, :betreuerinnen, :integer
  end
end
