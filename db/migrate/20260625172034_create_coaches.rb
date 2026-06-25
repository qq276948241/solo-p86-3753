class CreateCoaches < ActiveRecord::Migration[8.1]
  def change
    create_table :coaches do |t|
      t.string :name, null: false
      t.string :phone
      t.text :bio

      t.timestamps
    end

    add_index :coaches, :phone, unique: true
  end
end
