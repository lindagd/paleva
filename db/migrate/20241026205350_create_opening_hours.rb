class CreateOpeningHours < ActiveRecord::Migration[7.2]
  def change
    create_table :opening_hours do |t|
      t.integer :week_day, null: false
      t.time :open_time
      t.time :close_time
      t.integer :closed, default: 0
      t.references :establishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
