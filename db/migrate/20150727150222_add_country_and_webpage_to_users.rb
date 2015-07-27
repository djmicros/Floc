class AddCountryAndWebpageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country, :string
    add_column :users, :webpage, :string
  end
end
