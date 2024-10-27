class AddStateToEstablishment < ActiveRecord::Migration[7.2]
  def change
    add_column :establishments, :state, :string
  end
end
