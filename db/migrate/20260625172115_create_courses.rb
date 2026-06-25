class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.text :description
      t.integer :duration_minutes, null: false, default: 60

      t.timestamps
    end
  end
end
