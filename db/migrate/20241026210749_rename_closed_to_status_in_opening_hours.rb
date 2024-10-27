class RenameClosedToStatusInOpeningHours < ActiveRecord::Migration[7.2]
  def change
    rename_column :opening_hours, :closed, :status
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
