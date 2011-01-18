class AddCurrentToInterests < ActiveRecord::Migration
  def self.up
    add_column :interests, :current, :boolean
  end

  def self.down
    remove_column :interests, :current
  end
end
