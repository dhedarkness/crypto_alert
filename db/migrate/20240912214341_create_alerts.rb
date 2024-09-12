class CreateAlerts < ActiveRecord::Migration[7.2]
  def change
    create_table :alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cryptocurrency
      t.string :name
      t.decimal :target_price
      t.integer :status

      t.timestamps
    end
    add_index :alerts, :name, unique: true
  end
end
