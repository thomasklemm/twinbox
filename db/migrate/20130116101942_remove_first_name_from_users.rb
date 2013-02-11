class RemoveFirstNameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :first_name
    rename_column :users, :last_name, :name
  end

  def down
    rename_column :users, :name, :last_name
    add_column :users, :first_name, :text
  end
end
