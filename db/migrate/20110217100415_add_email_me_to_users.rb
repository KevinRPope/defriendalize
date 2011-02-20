class AddEmailMeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_me, :boolean, :default => true
  end

  def self.down
    remove_column :users, :email_me
  end
end
