class AddRoleToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :role, foreign_key: true
  end
end
