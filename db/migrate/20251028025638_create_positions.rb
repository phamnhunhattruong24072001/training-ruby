class CreatePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :positions do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    add_index :positions, :name, unique: true
  end
end
