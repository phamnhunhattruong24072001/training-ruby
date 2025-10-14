class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :password, null: false, default: ""
      t.string :username, null: false, default: ""
      t.string :name, null: true
      t.integer :phone, null: true
      t.string :role, default: 0
      t.timestamps
    end
  end
end
