#select `segment_damages`.*, `source`.name, `dest`.name, `spells`.name from `segment_damages`
#LEFT JOIN `units` AS `source` on `segment_damages`.`source_id` = `source`.`id`
#LEFT JOIN `units` AS `dest` on `segment_damages`.`dest_id` = `dest`.`id`
#LEFT JOIN `spells` on `segment_damages`.`spell_id` = `spells`.`id`

class Report < ActiveRecord::Base
	belongs_to :guild
	has_many :encounters, :dependent => :destroy
	has_many :segments, :dependent => :destroy
	has_many :events, :dependent => :destroy
	has_many :units, :dependent => :destroy
  has_many :auras, :class_name => "SegmentAura", :dependent => :destroy
  has_many :damages, :class_name => "SegmentDamage", :dependent => :destroy
  has_many :deaths, :class_name => "SegmentDeath", :dependent => :destroy
  has_many :dispels, :class_name => "SegmentDispel", :dependent => :destroy
  has_many :gains, :class_name => "SegmentGain", :dependent => :destroy
  has_many :heals, :class_name => "SegmentHeal", :dependent => :destroy
  has_many :interrupts, :class_name => "SegmentInterrupt", :dependent => :destroy
  has_many :steals, :class_name => "SegmentSteal", :dependent => :destroy

  #def to_param
  #	("%d_%s" % [self.id, self.label]).slug
  #end

	# reset_combat => nil
	#
	# Resets all combat data except attempt counter
	#
	def reset_combat
		@boss = {}
		@combat = false
		@encounter = nil
		@encounter_phase = 0
		@encounter_clock = 0.0
		@encounter_players = {}
		@encounter_last_activity = nil
		@segment = nil
		@segment_transitions = nil
	end


	# start_encounter (attributes) => nil
	#   
	#   :boss_name - name of boss, ex. The Lich King
	#   :occured_at - timestamp
	#   
	# Ends the current encounter (and segment)
	#
	def start_encounter(attributes)
		@combat = true
		@combat_cooldown_ends = 0
		@encounter_boss_name = attributes[:boss_name]
		@encounter_started_at = attributes[:occured_at]
		@encounter_last_activity = attributes[:occured_at]

		@boss = BOSSES[@boss_units[@encounter_boss_name]]
		@boss_attempts[@encounter_boss_name] += 1
		@boss_npcs = @boss['npcs'] || [{'name' => @boss['npc']['name']}]
		@encounter_count += 1

		if @encounter_count == 1 then
			self.started_at = attributes[:occured_at]
			self.save
		end

		p "Starting new Encounter: %s" % @boss['npc']['name']

		@encounter = Encounter.new
		@encounter.boss_id = @boss['npc']['id']
		@encounter.boss_name = @boss['npc']['name']
		@encounter.boss_is_heroic = false
		@encounter.attempt_number = @boss_attempts[@encounter_boss_name]
		@encounter.user_id = self.user_id
		@encounter.guild_id = self.guild_id
		@encounter.report_id = self.id
		@encounter.started_at = attributes[:occured_at]
		@encounter.save

		self.next_segment(:occured_at => attributes[:occured_at], :reason => "Default")
	end

	# next_segment (attributes) => nil
	#
	#   :occured_at - timestamp
	#
	# Ends the current segment and begins a new one
	#
	def next_segment(attributes)
		new_segments = {}

		if @segment then
			p "  Saving old Segment: Da:%d He:%d De:%d Ga:%d Di:%d St:%d In:%d Au:%d" % [ \
				@segment_damage.length, @segment_heal.length, @segment_death.length, \
				@segment_gain.length, @segment_dispel.length, @segment_steal.length, \
				@segment_interrupt.length, @segment_aura.length ]

			@segment.finished_at = attributes[:occured_at]
			@segment.save
			
			@segment_damage.each_value {|s| s.save }
			@segment_heal.each_value {|s| s.save }
			@segment_death.each_value {|s| s.save }
			@segment_gain.each_value {|s| s.save }
			@segment_dispel.each_value {|s| s.save }
			@segment_steal.each_value {|s| s.save }
			@segment_interrupt.each_value {|s| s.save }
			@segment_aura.each do |k, s|
				new_segments[k] = s.clone
				new_segments[k].aura_reset
				new_segments[k].aura_open(attributes[:occured_at], s.current_stacks) if s.open?
				s.aura_close(attributes[:occured_at])
				s.save
			end
		end

		@segment_damage = {}
		@segment_heal = {}
		@segment_death = {}
		@segment_aura = {}
		@segment_gain = {}
		@segment_dispel = {}
		@segment_steal = {}
		@segment_interrupt = {}
		
		@encounter_phase = attributes[:goto] || (@encounter_phase + 1)

		@segment_transitions = (@boss['transitions'] || []) + (@boss['segments'][@encounter_phase]['transitions'] || [])
		
		@segment = Segment.new
		@segment.phase = @encounter_phase
		@segment.group = @boss['segments'][@encounter_phase]['group'] || 0
		@segment.label = @boss['segments'][@encounter_phase]['label'] || "Phase #{@encounter_phase}"
		@segment.report_id = self.id
		@segment.encounter_id = @encounter.id
		@segment.started_at = attributes[:occured_at]
		@segment.save

		@segment_aura = new_segments
		@segment_aura.each_value {|s| s.segment_id = @segment.id }

		p "  Starting new Segment: %s (%s)" % [@encounter_phase, attributes[:reason]]
	end

	# end_segment (attributes) => nil
	#
	#   :occured_at - timestamp
	#
	# Ends the current encounter (and segment)
	#
	def end_encounter(attributes)

		if @segment then

			p "  Saving old Segment: Da:%d He:%d De:%d Ga:%d Di:%d St:%d In:%d Au:%d" % [ \
				@segment_damage.length, @segment_heal.length, @segment_death.length, \
				@segment_gain.length, @segment_dispel.length, @segment_steal.length, \
				@segment_interrupt.length, @segment_aura.length ]

			@segment.finished_at = attributes[:occured_at]
			@segment.save

			@segment_damage.each_value {|s| s.save }
			@segment_heal.each_value {|s| s.save }
			@segment_death.each_value {|s| s.save }
			@segment_gain.each_value {|s| s.save }
			@segment_dispel.each_value {|s| s.save }
			@segment_steal.each_value {|s| s.save }
			@segment_interrupt.each_value {|s| s.save }
			@segment_aura.each_value {|s| s.aura_close(@encounter_last_activity); s.save }
		end

		@units.each_value {|u| u.save }
		@spells.each_value {|s| s.save }

		@encounter.result_code = attributes[:result_code] || RESULT_NONE
		@encounter.finished_at = attributes[:occured_at]
		@encounter.player_count = @encounter_players.count
		@encounter.save

		@boss_attempts[@encounter_boss_name] = 0 if attributes[:result_code] == RESULT_SUCCESS
		@combat_cooldown_ends = attributes[:occured_at].to_i + (@boss['npc']['cooldown'] || 30)

		self.finished_at = @encounter_last_activity
		self.save

		p "  Stopped Encounter: %s (%s)" % [@boss['npc']['name'], attributes[:reason]]

		self.reset_combat
	end

	# preload_defaults => nil
	#
	# Must be called to set up a sane environment before processing log items
	#
	def preload_defaults
		# Load boss data
		@boss_units = {}
		@boss_attempts = {}
		BOSSES.each do |k, v|
			n = v['npc']['unit'] || v['npc']['name'] or next
			@boss_units[n] = k
			@boss_attempts[n] = 0
		end

		@units = {}
		@guid_cache = {}
		@encounter_count = 0
		@combat_cooldown_ends = 0

		# Reset combat data
		self.reset_combat
	end
	
	# preload_spells => nil
	#
	# Called to load all known spells into the database
	#
	def preload_spells
		@spells ||= {}
		Spell.all.each do |s|
			@spells[s.id] = s
		end
	end

	# get_unit(attributes) => Unit
	#
	# Call to fetch a unit from the cache (or make a new one)
	#
	def get_unit(attributes)
		guid = attributes[:guid]

		# Try instance cache
		@units ||= {}
		if @units[guid] then
			if attributes[:owner_id] and @units[guid].owner_id != attributes[:owner_id] then
				p "%s owner_id %d -> %d" % [@units[guid].name, @units[guid].owner_id, attributes[:owner_id]]
				@units[guid].owner_id = attributes[:owner_id]
			end
			if @units[guid].flags != attributes[:flags] then
				@units[guid].flags = attributes[:flags]
			end
			return @units[guid]
		end
		
		# New unit
		u = Unit.new(attributes)
		u.save
		@units[guid] = u
	end

	# map_guid => nil
	#
	# Maps non-player GUID's to something more meaningful
	#
	def map_guid(attributes)
		noun = case (attributes[:flags].to_i(16) & OBJECT_TYPE_MASK)
		when OBJECT_TYPE_NPC
			"NPC"
		when OBJECT_TYPE_PET, OBJECT_TYPE_GUARDIAN
			"PET"
		when OBJECT_TYPE_OBJECT
			"OBJECT"
		else
			"NONE"
		end

		_old_guid = attributes[:guid]
		_new_guid = ("%s_%s" % [noun, attributes[:name]]).slug.upcase

		@guid_cache[_old_guid] = _new_guid
	end

	# get_spell(attributes) => Spell
	#
	# Call to fetch a spell from the cache or database (or make a new one)
	#
	def get_spell(attributes)
		id = attributes[:id]

		# Try instance cache
		@spells ||= {}
		return @spells[id] if @spells[id]

		# Try database
		s = Spell.find(:first, :conditions => { :id => id })
		return s if s

		# New unit
		s = Spell.new(attributes)
		s.save
		@spells[id] = s
	end

	# parse_complete
	#
	# Closes open objects
	#
	def parse_complete
		end_encounter(:occured_at => @encounter_last_activity, :reason => "parse complete", :result_code => RESULT_WIPE) if @combat
	end

	# parse_log(str)
	#
	#   str - well formed WOW log line
	#
	# Parses a log into the current report
	#
	def parse_log(str)
		r = str.chomp.split(",")
		time, event = r[0].split("  ")

		# Skip invalid time strings
		if !time or !event
			p "Parse Error: no time in string: " + str
			return false
		end
		
		if not time =~ /^\d{1,2}\/\d{1,2} \d{2}:\d{2}:\d{2}\.\d{3}$/
			p "Parse Error: bad time object: " + time
			return false
		end
		
		# Try parsing the time
		t = Time.parse_wow(time)
		
		# If we couldn't parse the time, return false
		if t == false
			p "Parse Error: couldn't parse time: " + time
			return false
		end
		if not r[1] =~ /0x[A-Fa-f0-9]{16}/ then
			p "Parse Error: Bad Source GUID: " + str
			return false
		end
		if not r[4] =~ /0x[A-Fa-f0-9]{16}/
			p "Parse Error: Bad Dest GUID: " + str
			return false
		end
		if not r[3] =~ /0x[A-Fa-f0-9]{1,16}/
			p "Parse Error: Bad Source Flags: " + str
			return false
		end
		if not r[6] =~ /0x[A-Fa-f0-9]{1,16}/
			p "Parse Error: Bad Dest Flags: " + str
			return false
		end

		# Simplify odd events
		event = "SPELL_DAMAGE" if event == "DAMAGE_SHIELD" or event == "DAMAGE_SPLIT"
		event = "SPELL_MISSED" if event == "DAMAGE_SHIELD_MISSED"

		_source = { :report_id => self.id, :name => r[2].unquote, :guid => r[1], :flags => r[3], :source_guid => r[1] }
		_dest = { :report_id => self.id, :name => r[5].unquote, :guid => r[4], :flags => r[6], :source_guid => r[4] }

		# If our source is nil, make it the same as dest
		_source = _dest if _source[:name] == "nil" and _source[:guid] == "0x0000000000000000"
		
		# If a PLAYER summons a PET/GUARDIAN
		if (event == "SPELL_SUMMON" or event == "SPELL_CREATE") and Unit.guid_is_a_player(_source[:source_guid]) then
			source = self.get_unit(_source)
			_old_guid = _dest[:guid]
			_new_guid = ("PET_%s_%s" % [_source[:name], _dest[:name]]).slug.upcase
			_dest[:guid] = _new_guid
			_dest[:owner_id] = source[:id]
			@guid_cache[_old_guid] = _new_guid
		end

		self.map_guid(_source) if not @guid_cache[_source[:guid]] and not Unit.guid_is_a_player(_source[:source_guid]) and _source[:guid] =~ /^0x/
		_source[:guid] = @guid_cache[_source[:guid]] if @guid_cache[_source[:guid]]

		# If a PET/GUARDIAN summons a PET/GUARDIAN
		# SPELL_SUMMON,0xF130003C4F00984F,"Fire Elemental Totem",0x2114,0xF130003C4E009850,"Greater Fire Elemental",0x2114,32982,"Fire Elemental Totem",0x1
		if (event == "SPELL_SUMMON" or event == "SPELL_CREATE") and (Unit.flags_is_a_pet(_source[:flags]) or Unit.flags_is_a_guardian(_source[:flags])) then
			source = self.get_unit(_source)

			_owner = Unit.find(:first, :conditions => { :id => source[:owner_id] })
			_owner_name = _owner ? _owner.name : _source[:owner_id]
			_old_guid = _dest[:guid]
			_new_guid = ("PET_%s_%s" % [_owner_name, _dest[:name]]).slug.upcase
			_dest[:guid] = _new_guid
			_dest[:owner_id] = source[:owner_id]
			@guid_cache[_old_guid] = _new_guid

		end

		self.map_guid(_dest) if not @guid_cache[_dest[:guid]] and not Unit.guid_is_a_player(_dest[:source_guid]) and _dest[:guid] =~ /^0x/
		_dest[:guid] = @guid_cache[_dest[:guid]] if @guid_cache[_dest[:guid]]
		
		if _source[:guid] =~ /0xF130008EF50130D5/ or _dest[:guid] =~ /0xF130008EF50130D5/
			p "!!!"
			p str
		end

		source = self.get_unit(_source) if not source
		dest = self.get_unit(_dest) if not dest
		
		# We need to know about summoned pets regardless of combat
		
		# If we're not in combat, try to bring us there
		self.start_encounter(:boss_name => dest.name, :occured_at => t) if not @combat and t.to_i > @combat_cooldown_ends and @boss_units.include?(dest.name) and (event =~ /_DAMAGE$/ or event =~ /^SWING_/ or event =~ /_HEAL$/)
		
		# If we're still not in combat, skip this line
		return if not @combat

		# Our environment becomes sane here, but at a cost - put lightweight checks above!

		# Bump activity if a known unit shows up in the combat log
		# @encounter_last_activity = t if [source.name, dest.name].include?(@boss['npc']['unit'] || @boss['npc']['name'])
		if @boss_npcs
			@boss_npcs.each do |u|
				@encounter_last_activity = t if [source.name, dest.name].include?(u['name'])
			end
		end

		e = Event.new
		e.event = event
		e.report_id = self.id
		e.encounter_id = @encounter.id
		e.segment_id = @segment.id
		e.occured_at = Time.parse_wow(time)
		e.source_id = source.id
		e.dest_id = dest.id

		case event
			when /^SP/, /^RA/
				spell = self.get_spell(:id => r[7].to_i, :name => r[8].unquote, :school => r[9].to_i(16))
				e.spell_id = spell.id
				p = r[10..-1]
			when /^SW/
				spell = self.get_spell(:id => -1, :name => "Melee", :school => SCHOOL_PHYSICAL)
				e.spell_id = spell.id
				p = r[7..-1]
			when /^EN/
				spell = self.get_spell(:id => -2, :name => r[7].capitalize, :school => SCHOOL_NONE)
				e.spell_id = spell.id
				p = r[8..-1]
			else
				spell = self.get_spell(:id => -3, :name => "Other", :school => SCHOOL_NONE)
				p = []
		end

		# Determine things about this event
		is_periodic = event =~ /_PERIODIC_/ ? true : false
		is_friendlyfire = false
		is_friendlyfire = true if event =~ /_DAMAGE/ and (source.player? or source.pet? or source.vehicle?) and (dest.player? or dest.pet? or source.vehicle?)
		is_friendlyfire = true if event =~ /_DAMAGE/ and source == dest
		h = "%d_%d_%d_%s_%s" % [source.id, dest.id, spell.id, is_periodic.to_s, is_friendlyfire.to_s]
		
		case event
			when /_DAMAGE$/
				p.collect! {|x| x.to_i }
				e.amount, e.overkill, j, e.resisted, e.blocked, e.absorbed,
					e.critical, e.glancing, e.crushing = p.to_integers
        
        j ||= nil # get rid of unused variable warning
        
				@segment_damage[h] ||= SegmentDamage.new(
						:unit_id => (source.owner_id ? source.owner_id : source.id), :source_id => source.id, :dest_id => dest.id,
						:spell_id => spell.id, :is_periodic => is_periodic, :is_friendlyfire => is_friendlyfire,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)

				@segment_damage[h].amount_hits += e.amount if not e.critical
				@segment_damage[h].amount_crits += e.amount if e.critical
				@segment_damage[h].amount_absorbs += e.absorbed
				@segment_damage[h].amount_blocks += e.blocked

				@segment_damage[h].amount_min_hit ||= e.amount if not e.critical
				@segment_damage[h].amount_min_crit ||= e.amount if e.critical
				@segment_damage[h].amount_min_absorb ||= e.absorbed if e.absorbed
				@segment_damage[h].amount_min_block ||= e.blocked if e.blocked

				@segment_damage[h].amount_min_hit = e.amount if e.amount < @segment_damage[h].amount_min_hit and not e.critical
				@segment_damage[h].amount_min_crit = e.amount if e.amount < @segment_damage[h].amount_min_crit and e.critical
				@segment_damage[h].amount_min_absorb = e.absorbed if e.absorbed < @segment_damage[h].amount_min_absorb
				@segment_damage[h].amount_min_block = e.blocked if e.blocked < @segment_damage[h].amount_min_block

				@segment_damage[h].amount_max_hit = e.amount if e.amount > @segment_damage[h].amount_max_hit and not e.critical
				@segment_damage[h].amount_max_crit = e.amount if e.amount > @segment_damage[h].amount_max_crit and e.critical
				@segment_damage[h].amount_max_absorb = e.absorbed if e.absorbed > @segment_damage[h].amount_max_absorb
				@segment_damage[h].amount_max_block = e.blocked if e.blocked > @segment_damage[h].amount_max_block
				
				@segment_damage[h].num_hits += 1 if not e.critical
				@segment_damage[h].num_crits += 1 if e.critical
				@segment_damage[h].num_glancings += 1 if e.glancing
				@segment_damage[h].num_crushings += 1 if e.crushing

			when /HEAL$/
				e.amount, e.overkill, e.absorbed, e.critical = p.to_integers
				e.amount -= (e.overkill||0)

				@segment_heal[h] ||= SegmentHeal.new(
						:unit_id => (source.owner_id ? source.owner_id : source.id), :source_id => source.id, :dest_id => dest.id,
						:spell_id => spell.id, :is_periodic => is_periodic,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)

				@segment_heal[h].amount_hits += e.amount if not e.critical
				@segment_heal[h].amount_crits += e.amount if e.critical
				@segment_heal[h].amount_overheal += e.overkill
				@segment_heal[h].amount_absorbs += e.absorbed
				
				@segment_heal[h].amount_min_hit ||= e.amount if not e.critical
				@segment_heal[h].amount_min_crit ||= e.amount if e.critical
				@segment_heal[h].amount_min_overheal ||= e.overkill
				@segment_heal[h].amount_min_absorb ||= e.absorbed if e.absorbed

				@segment_heal[h].amount_min_hit = e.amount if e.amount < @segment_heal[h].amount_min_hit and not e.critical
				@segment_heal[h].amount_min_crit = e.amount if e.amount < @segment_heal[h].amount_min_crit and e.critical
				@segment_heal[h].amount_min_overheal = e.overkill if e.overkill < @segment_heal[h].amount_min_overheal
				@segment_heal[h].amount_min_absorb = e.absorbed if e.absorbed < @segment_heal[h].amount_min_absorb

				@segment_heal[h].amount_max_hit = e.amount if e.amount > @segment_heal[h].amount_max_hit and not e.critical
				@segment_heal[h].amount_max_crit = e.amount if e.amount > @segment_heal[h].amount_max_crit and e.critical
				@segment_heal[h].amount_max_overheal = e.overkill if e.overkill > @segment_heal[h].amount_max_overheal
				@segment_heal[h].amount_max_absorb = e.absorbed if e.absorbed > @segment_heal[h].amount_max_absorb

				@segment_heal[h].num_hits += 1 if not e.critical
				@segment_heal[h].num_crits += 1 if e.critical
				@segment_heal[h].num_overheals += 1 if e.overkill > 0
				@segment_heal[h].num_absorbs += 1 if e.absorbed > 0

			when /_MISSED$/
				e.type, e.amount, e.type = p[0], p[1].to_i

				@segment_damage[h] ||= SegmentDamage.new(
						:unit_id => (source.owner_id ? source.owner_id : source.id), :source_id => source.id, :dest_id => dest.id,
						:spell_id => spell.id, :is_periodic => is_periodic, :is_friendlyfire => is_friendlyfire,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)

				case e.type
					when "ABSORB"
						@segment_damage[h].amount_absorbs += e.amount
						@segment_damage[h].num_absorbs += 1
						@segment_damage[h].amount_min_absorb ||= e.amount if e.amount
						@segment_damage[h].amount_min_absorb = e.amount if e.amount < @segment_damage[h].amount_min_absorb
						@segment_damage[h].amount_max_absorb = e.amount if e.amount > @segment_damage[h].amount_max_absorb
					when "IMMUNE"
						@segment_damage[h].num_immunes += 1
					when "BLOCK"
						@segment_damage[h].amount_blocks += e.amount
						@segment_damage[h].num_blocks += 1
						@segment_damage[h].amount_min_block ||= e.amount if e.amount
						@segment_damage[h].amount_min_block = e.amount if e.amount < @segment_damage[h].amount_min_block
						@segment_damage[h].amount_max_block = e.amount if e.amount > @segment_damage[h].amount_max_block
					when "DODGE"
						@segment_damage[h].num_dodges += 1
					when "MISS"
						@segment_damage[h].num_misses += 1
					when "PARRY"
						@segment_damage[h].num_parries += 1
				end

			when /_ENERGIZE$/
				e.amount, e.type = p[0].to_i, p[1]

				@segment_gain[h] ||= SegmentGain.new(
						:source_id => source.id, :dest_id => dest.id, :spell_id => spell.id, :gain_type => e.type,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)

				@segment_gain[h].amount_total += e.amount
				@segment_gain[h].amount_min ||= e.amount
				@segment_gain[h].amount_min = e.amount if e.amount < @segment_gain[h].amount_min
				@segment_gain[h].amount_max = e.amount if e.amount > @segment_gain[h].amount_max
				@segment_gain[h].num_total += 1

			when /_DISPEL$/
				e.extra_spell_id = self.get_spell(:id => p[0].to_i, :name => p[1].unquote, :school => p[2].to_i(16)).id
				e.type = p[3].unquote if p[3]

				aura_type = case e.type
					when "BUFF"
						AURA_BUFF
					when "DEBUFF"
						AURA_DEBUFF
					else
						AURA_NONE
				end

				@segment_dispel[h] ||= SegmentDispel.new(
						:source_id => source.id, :dest_id => dest.id, :spell_id => spell.id, :extra_spell_id => e.extra_spell_id,
						:aura_type => aura_type, :report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)
				@segment_dispel[h].num_total += 1

			when /_STOLEN$/
				e.extra_spell_id = self.get_spell(:id => p[0].to_i, :name => p[1].unquote, :school => p[2].to_i(16)).id
				e.type = p[3].unquote if p[3]

				aura_type = case e.type
					when "BUFF"
						AURA_BUFF
					when "DEBUFF"
						AURA_DEBUFF
					else
						AURA_NONE
				end

				@segment_steal[h] ||= SegmentSteal.new(
						:source_id => source.id, :dest_id => dest.id, :spell_id => spell.id, :extra_spell_id => e.extra_spell_id,
						:aura_type => aura_type, :report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)
				@segment_steal[h].num_total += 1

			when /_INTERRUPT$/
				e.extra_spell_id = self.get_spell(:id => p[0].to_i, :name => p[1].unquote, :school => p[2].to_i(16)).id

				@segment_interrupt[h] ||= SegmentInterrupt.new(
						:source_id => source.id, :dest_id => dest.id, :spell_id => spell.id, :extra_spell_id => e.extra_spell_id,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)
				@segment_interrupt[h].num_total += 1
				
			when /_AURA_/
				e.type = p[0].unquote
				e.amount = p[1].to_i if p[1]

				aura_type = case e.type
					when "BUFF"
						AURA_BUFF
					when "DEBUFF"
						AURA_DEBUFF
					else
						AURA_NONE
				end

				@segment_aura[h] ||= SegmentAura.new(
						:source_id => source.id, :dest_id => dest.id, :spell_id => spell.id, :aura_type => aura_type,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)

				case event
				when /_AURA_APPLIED/
					@segment_aura[h].aura_apply(t, e.amount||1)
				when /_AURA_REFRESH/
					@segment_aura[h].aura_apply(@segment.started_at, 1) if not @segment_aura[h].open?
				when /_AURA_REMOVED/
					@segment_aura[h].aura_apply(@segment.started_at, 1) if not @segment_aura[h].open?
					# Then remove it regardless
					@segment_aura[h].aura_remove(t)
				end

			when /_EXTRA_ATTACKS$/
				e.amount = p[0].to_i || 0

				@segment_damage[h] ||= SegmentDamage.new(
						:unit_id => (source.owner_id ? source.owner_id : source.id), :source_id => source.id, :dest_id => dest.id,
						:spell_id => spell.id, :is_periodic => is_periodic, :is_friendlyfire => is_friendlyfire,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)

				@segment_damage[h].num_extras += e.amount if e.amount

			when /^UNIT_DIED$/
				@segment_death[h] ||= SegmentDeath.new(
						:unit_id => dest.id, :occured_at => t,
						:report_id => self.id, :encounter_id => @encounter.id, :segment_id => @segment.id)

		end

		#e.save


		# Insert players as necessary
		@encounter_players[source.name] ||= source if source.player?

		# Assign class to player
		if source.player? and not source.class_id then
			CLASSES.each_value do |c|
				c['spells'].each do |s|
					if s['spell'] == spell.name
						source.class_id = c['id']
            break
					end
				end
			end
		end
		
		# Assign pet to player
		dest.owner_id = source.id if spell.name == "Soul Link" and event == "SPELL_DAMAGE" and source.player? and dest.pet?
		dest.owner_id = source.id if spell.name == "Fel Synergy" and event == "SPELL_HEAL" and source.player? and dest.pet?
		dest.owner_id = source.id if spell.name == "Go for the Throat" and event == "SPELL_ENERGIZE" and source.player? and dest.pet?
		source.owner_id = dest.id if spell.name == "Culling the Herd" and event == "SPELL_AURA_APPLIED" and source.pet? and dest.player?
		source.owner_id = dest.id if spell.name == "Furious Howl" and event == "SPELL_AURA_APPLIED" and source.pet? and dest.player?
		
		# Set heroic if the boss [heroic_event/heroic_spell]
		@encounter.boss_is_heroic = true if not @encounter.boss_is_heroic and @encounter and @boss['npc']['heroic'] and \
			(@boss['npc']['heroic']['event'] == event or not @boss['npc']['heroic']['event']) and \
			(@boss['npc']['heroic']['spell'] == spell.name or not @boss['npc']['heroic']['spell']) and \
			(@boss['npc']['heroic']['source'] == source.name or not @boss['npc']['heroic']['source']) and \
			(@boss['npc']['heroic']['dest'] == dest.name or not @boss['npc']['heroic']['dest'])

		# Our environment starts to possibly destruct here, be careful adding new statements

		# Next segment if the boss twitches
		if @segment and @segment_transitions then
			@segment_transitions.each do |s|
				self.next_segment(:occured_at => t, :reason => spell.name, :goto => s['goto']) if \
					(s['event'] == event or not s['event']) and \
					(s['spell'] == spell.name or not s['spell']) and \
					(s['source'] == source.name or not s['source']) and \
					(s['dest'] == dest.name or not s['dest'])
			end
		end

		#self.next_segment(:occured_at => t, :spell_name => spell.name) if @segment and spell.name == @boss['segments'][@encounter_phase]['next_spell'] and event == @boss['segments'][@encounter_phase]['next_event'] and source.name == @boss['npc']['name']

		# End the encounter if the boss [end_event/end_spell]
		self.end_encounter(:occured_at => t, :reason => "boss died", :result_code => RESULT_SUCCESS) if @encounter and @boss['npc']['end'] and \
			(@boss['npc']['end']['event'] == event or not @boss['npc']['end']['event']) and \
			(@boss['npc']['end']['spell'] == spell.name or not @boss['npc']['end']['spell']) and \
			(@boss['npc']['end']['source'] == source.name or not @boss['npc']['end']['source']) and \
			(@boss['npc']['end']['dest'] == dest.name or not @boss['npc']['end']['dest'])

		# End the encounter if we timeout
		self.end_encounter(:occured_at => t, :reason => "inactivity", :result_code => RESULT_FAILURE) if @encounter and (t.to_f - @encounter_last_activity.to_f) > (@boss['npc']['timeout'] || 10)

		# End the encounter if the boss dies
		self.end_encounter(:occured_at => t, :reason => "boss died", :result_code => RESULT_SUCCESS) if @encounter and event =~ /^UNIT_DIED$/ and dest.name == (@boss['npc']['unit'] || @boss['npc']['name'])

	end

end
