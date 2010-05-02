class CreateEncounters < ActiveRecord::Migration
  def self.up
    create_table :encounters do |t|
      t.integer :boss_id
			t.string :boss_name
			t.boolean :boss_is_heroic, :default => 0
			t.integer :player_count, :default => 0
      t.integer :attempt_number, :default => 0
      t.integer :result_code, :default => 0
      t.integer :user_id
      t.integer :guild_id
			t.integer :report_id
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
  end

  def self.down
    drop_table :encounters
  end
end
