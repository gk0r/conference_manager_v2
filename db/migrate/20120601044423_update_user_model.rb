class UpdateUserModel < ActiveRecord::Migration
  def up
    add_column :users, :admin_notifications, :boolean, :default => false
  end

  def down
    remove_column :users, :admin_notifications
  end
end
