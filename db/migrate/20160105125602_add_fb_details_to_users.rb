class AddFbDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :fb_id, :string
    add_column :users, :avatar, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_expires_at, :datetime
  end
end
