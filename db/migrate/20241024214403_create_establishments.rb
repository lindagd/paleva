class CreateEstablishments < ActiveRecord::Migration[7.2]
  def change
    create_table :establishments do |t|
      t.string :trade_name
      t.string :corporate_name
      t.string :registration_number
      t.string :city
      t.string :zip
      t.string :address
      t.string :phone_number
      t.string :email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
