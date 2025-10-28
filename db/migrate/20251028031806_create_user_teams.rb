class CreateUserTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :user_teams do |t|
      t.string   :username,           null: false, default: ""
      t.string   :email,              null: false, default: ""
      t.string   :encrypted_password, null: false, default: ""

      t.string   :fullname
      t.string   :display_name
      t.string   :phone
      t.date     :birth_day

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at

      t.references :role, null: false
      t.references :position, null: false
      t.references :team, null: false

      t.timestamps
    end

    add_index :user_teams, :username, unique: true
    add_index :user_teams, :email, unique: true
  end
end
