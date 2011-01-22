class AddLocationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :string
    add_column :users, :relationship_status, :string
    add_column :connections, :user_id, :integer
    add_column :interests, :user_id, :integer
    add_index :connections, :user_id
    add_index :interests, :user_id
  end
  

  def self.down
    remove_column :users, :location
  end
end
