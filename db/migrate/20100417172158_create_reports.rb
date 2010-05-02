class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :label, :null => false, :limit => 128
      t.integer :user_id
      t.integer :guild_id
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
