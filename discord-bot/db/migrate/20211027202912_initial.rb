class Initial < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.integer :created_by_discord_user_id, null: false
      t.integer :discord_server_id, null: false
      t.datetime :start_time, null: false
      t.integer :required_players, null: false
      t.text :name, null: false

      t.timestamps
    end

    create_table :event_players do |t|
      t.references :event, foreign_key: { to_table: :events, on_delete: :cascade }, index: true
      t.integer :discord_user_id, null: false

      t.timestamps
    end

    add_index :event_players, %i[event_id discord_user_id], unique: true
  end
end
