class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :member, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :bookings, [:member_id, :schedule_id]
  end
end
