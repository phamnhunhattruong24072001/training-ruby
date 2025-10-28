class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false, default: ""
      t.string :code, null: false, default: ""
      t.text :description
      t.integer :status, null: false, default: 3, comment: "0: Super Admin, 1: Admin, 2: Manager, 3: User"
      t.timestamps
    end

    add_index :roles, :name, unique: true
    add_index :roles, :code, unique: true
  end
end
