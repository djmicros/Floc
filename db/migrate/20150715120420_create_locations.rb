class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.text :desc
      t.string :geo
      t.boolean :electricity
      t.boolean :open
      t.boolean :public
      t.references :user

      t.timestamps
    end
    add_index :locations, :user_id
  end
end
