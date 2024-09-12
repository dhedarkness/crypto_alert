class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :name, unique: true
  end
end
