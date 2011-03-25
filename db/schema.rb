# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100504222205) do

  create_table "bosses", :force => true do |t|
    t.integer  "zone_id"
    t.integer  "seq"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "encounters", :force => true do |t|
    t.integer  "boss_id"
    t.string   "boss_name"
    t.boolean  "boss_is_heroic", :default => false
    t.integer  "player_count",   :default => 0
    t.integer  "attempt_number", :default => 0
    t.integer  "result_code",    :default => 0
    t.integer  "user_id"
    t.integer  "guild_id"
    t.integer  "report_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "event",          :limit => 64, :null => false
    t.integer  "source_id"
    t.integer  "dest_id"
    t.integer  "spell_id"
    t.integer  "extra_spell_id"
    t.integer  "amount"
    t.integer  "overkill"
    t.integer  "resisted"
    t.integer  "blocked"
    t.integer  "absorbed"
    t.boolean  "critical"
    t.boolean  "glancing"
    t.boolean  "crushing"
    t.string   "type",           :limit => 32
    t.integer  "report_id"
    t.integer  "encounter_id"
    t.integer  "segment_id"
    t.datetime "occured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["report_id", "encounter_id", "dest_id"], :name => "index_events_on_report_id_and_encounter_id_and_dest_id"
  add_index "events", ["report_id", "encounter_id", "source_id"], :name => "index_events_on_report_id_and_encounter_id_and_source_id"
  add_index "events", ["report_id", "encounter_id", "spell_id"], :name => "index_events_on_report_id_and_encounter_id_and_spell_id"
  add_index "events", ["report_id"], :name => "index_events_on_report_id"

  create_table "guilds", :force => true do |t|
    t.string   "region",     :limit => 8,   :null => false
    t.string   "realm",      :limit => 32,  :null => false
    t.string   "name",       :limit => 128, :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.string   "label",       :limit => 128, :null => false
    t.integer  "user_id"
    t.integer  "guild_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_auras", :force => true do |t|
    t.integer  "source_id",                     :null => false
    t.integer  "dest_id",                       :null => false
    t.integer  "spell_id",                      :null => false
    t.integer  "aura_type",      :default => 0
    t.integer  "aura_duration",  :default => 0
    t.integer  "num_gained",     :default => 0
    t.integer  "num_lost",       :default => 0
    t.integer  "num_stacks_max", :default => 0
    t.integer  "report_id",                     :null => false
    t.integer  "encounter_id",                  :null => false
    t.integer  "segment_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_damages", :force => true do |t|
    t.integer  "unit_id",                              :null => false
    t.integer  "source_id",                            :null => false
    t.integer  "dest_id",                              :null => false
    t.integer  "spell_id",                             :null => false
    t.boolean  "is_periodic",       :default => false
    t.boolean  "is_friendlyfire",   :default => false
    t.integer  "amount_total",      :default => 0
    t.integer  "amount_hits",       :default => 0
    t.integer  "amount_crits",      :default => 0
    t.integer  "amount_absorbs",    :default => 0
    t.integer  "amount_blocks",     :default => 0
    t.integer  "amount_glancings",  :default => 0
    t.integer  "amount_crushings",  :default => 0
    t.integer  "amount_min_hit",    :default => 0
    t.integer  "amount_max_hit",    :default => 0
    t.integer  "amount_min_crit",   :default => 0
    t.integer  "amount_max_crit",   :default => 0
    t.integer  "amount_min_absorb", :default => 0
    t.integer  "amount_max_absorb", :default => 0
    t.integer  "amount_min_block",  :default => 0
    t.integer  "amount_max_block",  :default => 0
    t.integer  "num_total",         :default => 0
    t.integer  "num_hits",          :default => 0
    t.integer  "num_crits",         :default => 0
    t.integer  "num_misses",        :default => 0
    t.integer  "num_absorbs",       :default => 0
    t.integer  "num_blocks",        :default => 0
    t.integer  "num_dodges",        :default => 0
    t.integer  "num_parries",       :default => 0
    t.integer  "num_immunes",       :default => 0
    t.integer  "num_glancings",     :default => 0
    t.integer  "num_crushings",     :default => 0
    t.integer  "num_extras",        :default => 0
    t.integer  "report_id",                            :null => false
    t.integer  "encounter_id",                         :null => false
    t.integer  "segment_id",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_deaths", :force => true do |t|
    t.integer  "unit_id",      :null => false
    t.integer  "report_id",    :null => false
    t.integer  "encounter_id", :null => false
    t.integer  "segment_id",   :null => false
    t.datetime "occured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_dispels", :force => true do |t|
    t.integer  "source_id",                     :null => false
    t.integer  "dest_id",                       :null => false
    t.integer  "spell_id",                      :null => false
    t.integer  "extra_spell_id"
    t.integer  "aura_type",      :default => 0
    t.integer  "num_total",      :default => 0
    t.integer  "report_id",                     :null => false
    t.integer  "encounter_id",                  :null => false
    t.integer  "segment_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_gains", :force => true do |t|
    t.integer  "source_id",                   :null => false
    t.integer  "dest_id",                     :null => false
    t.integer  "spell_id",                    :null => false
    t.integer  "gain_type",    :default => 0
    t.integer  "amount_total", :default => 0
    t.integer  "amount_min",   :default => 0
    t.integer  "amount_max",   :default => 0
    t.integer  "num_total",    :default => 0
    t.integer  "report_id",                   :null => false
    t.integer  "encounter_id",                :null => false
    t.integer  "segment_id",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_heals", :force => true do |t|
    t.integer  "unit_id",                                :null => false
    t.integer  "source_id",                              :null => false
    t.integer  "dest_id",                                :null => false
    t.integer  "spell_id",                               :null => false
    t.boolean  "is_periodic",         :default => false
    t.integer  "amount_total",        :default => 0
    t.integer  "amount_hits",         :default => 0
    t.integer  "amount_crits",        :default => 0
    t.integer  "amount_overheal",     :default => 0
    t.integer  "amount_absorbs",      :default => 0
    t.integer  "amount_min_hit",      :default => 0
    t.integer  "amount_max_hit",      :default => 0
    t.integer  "amount_min_crit",     :default => 0
    t.integer  "amount_max_crit",     :default => 0
    t.integer  "amount_min_overheal", :default => 0
    t.integer  "amount_max_overheal", :default => 0
    t.integer  "amount_min_absorb",   :default => 0
    t.integer  "amount_max_absorb",   :default => 0
    t.integer  "num_total",           :default => 0
    t.integer  "num_hits",            :default => 0
    t.integer  "num_crits",           :default => 0
    t.integer  "num_overheals",       :default => 0
    t.integer  "num_absorbs",         :default => 0
    t.integer  "report_id",                              :null => false
    t.integer  "encounter_id",                           :null => false
    t.integer  "segment_id",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_interrupts", :force => true do |t|
    t.integer  "source_id",                     :null => false
    t.integer  "dest_id",                       :null => false
    t.integer  "spell_id",                      :null => false
    t.integer  "extra_spell_id"
    t.integer  "num_total",      :default => 0
    t.integer  "report_id",                     :null => false
    t.integer  "encounter_id",                  :null => false
    t.integer  "segment_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segment_steals", :force => true do |t|
    t.integer  "source_id",                     :null => false
    t.integer  "dest_id",                       :null => false
    t.integer  "spell_id",                      :null => false
    t.integer  "extra_spell_id"
    t.integer  "aura_type",      :default => 0
    t.integer  "num_total",      :default => 0
    t.integer  "report_id",                     :null => false
    t.integer  "encounter_id",                  :null => false
    t.integer  "segment_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segments", :force => true do |t|
    t.integer  "phase",                       :default => 0
    t.string   "group",        :limit => 64
    t.string   "label",        :limit => 128,                :null => false
    t.integer  "report_id"
    t.integer  "encounter_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spells", :force => true do |t|
    t.string   "name",       :limit => 128,                :null => false
    t.integer  "school",                    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name",         :limit => 128,                    :null => false
    t.string   "guid",         :limit => 64,                     :null => false
    t.string   "source_guid",  :limit => 64,                     :null => false
    t.string   "flags"
    t.boolean  "is_player",                   :default => false
    t.boolean  "is_pet",                      :default => false
    t.boolean  "is_npc",                      :default => false
    t.integer  "class_id"
    t.integer  "npc_id"
    t.integer  "owner_id"
    t.integer  "report_id"
    t.integer  "encounter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["report_id", "guid"], :name => "index_units_on_report_id_and_guid", :unique => true

  create_table "zones", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
