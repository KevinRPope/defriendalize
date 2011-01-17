class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections do |t|
      t.string :user_facebook_id
      t.string :friend_facebook_id
      t.string :friend_name
      t.string :last_action

      t.timestamps
    end
  end

  def self.down
    drop_table :connections
  end
end
