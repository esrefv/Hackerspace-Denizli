class AddCardnumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cardnumber, :string
  end

end
