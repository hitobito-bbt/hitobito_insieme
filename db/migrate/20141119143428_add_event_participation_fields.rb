class AddEventParticipationFields < ActiveRecord::Migration
  def up
    add_column :event_participations, :disability, :string
    add_column :event_participations, :multiple_disability, :boolean
    add_column :event_participations, :wheel_chair, :boolean, null: false, default: false

    rename_column :event_participations, :invoice_text, :invoice_text
    rename_column :event_participations, :invoice_amount, :invoice_amount

    add_column :people, :ahv_number, :string

    Event::Question.where(event_id: nil).destroy_all
  end

  def down
    remove_column :people, :ahv_number

    rename_column :event_participations, :invoice_text, :invoice_text
    rename_column :event_participations, :invoice_amount, :invoice_amount

    remove_column :event_participations, :wheel_chair
    remove_column :event_participations, :multiple_disability
    remove_column :event_participations, :disability
  end
end
