class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.datetime :member_since, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :members, :phone, unique: true
  end
end
