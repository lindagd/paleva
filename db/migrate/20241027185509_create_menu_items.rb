class CreateMenuItems < ActiveRecord::Migration[7.2]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.string :description
      t.integer :calories
      t.references :establishment, null: false, foreign_key: true
      t.references :itemable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
