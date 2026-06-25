class CreateCheckIns < ActiveRecord::Migration[8.1]
  def change
    create_table :check_ins do |t|
      t.references :booking, null: false, foreign_key: true, index: false
      t.datetime :checked_in_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :check_ins, :booking_id, unique: true
  end
end
