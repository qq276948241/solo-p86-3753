class CreateSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :schedules do |t|
      t.references :course, null: false, foreign_key: true
      t.references :coach, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.integer :capacity, null: false, default: 12

      t.timestamps
    end

    add_index :schedules, [:coach_id, :start_time], unique: true
  end
end
