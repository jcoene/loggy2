class SegmentHeal < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	belongs_to :segment
	belongs_to :source, :class_name => "Unit"
	belongs_to :dest, :class_name => "Unit"
	belongs_to :spell

	#def after_initialize
	#	self.is_periodic ||= false
	#	self.amount_total, self.amount_hits, self.amount_crits, self.amount_absorbs = 0
	#	self.num_total, self.num_hits, self.num_crits, self.num_absorbs = 0
	#end

	def SegmentHeal.done(attr = {})

		source_t = "units"

    attr[:conditions] ||= {}
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr[:is_player]
		attr[:conditions]['segment_id'] = attr[:segments] if attr.has_key?(:segments)
    
		self.find(:all, {
							:select =>
									"DISTINCT(source_id) AS source_id, #{source_t}.name AS source_name, #{source_t}.npc_id AS source_npc_id, #{source_t}.class_id AS source_class_id, " +
									"SUM(amount_total) AS amount_total, SUM(amount_hits) AS amount_hits, SUM(amount_crits) AS amount_crits, SUM(amount_overheal) AS amount_overheal, SUM(amount_absorbs) AS amount_absorbs, " +
									"SUM(num_total) AS num_total, SUM(num_hits) AS num_hits, SUM(num_crits) AS num_crits, SUM(num_overheals) AS num_overheals, SUM(num_absorbs) AS num_absorbs",
							:conditions => attr[:conditions],
							:joins => [ :source ],
							:order => "amount_total desc",
							:group => :source_id })
	end

	def SegmentHeal.done_spells(attr = {})

		source_t = "units"

    attr[:conditions] ||= {}
    attr[:conditions]['source_id'] = attr[:source_id] if attr.has_key?(:source_id)
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr.has_key?(:is_player)
    attr[:conditions]['units.is_npc'] = attr[:is_npc] if attr.has_key?(:is_npc)
		attr[:conditions]['segment_id'] = attr[:segments] if attr.has_key?(:segments)

		self.find(:all, {
							:select =>
									"DISTINCT(source_id) AS source_id, #{source_t}.name AS source_name, #{source_t}.npc_id AS source_npc_id, #{source_t}.class_id AS source_class_id, " +
									"spell_id, spells.name AS spell_name, spells.school AS spell_school, " +
									"SUM(amount_total) AS amount_total, SUM(amount_hits) AS amount_hits, SUM(amount_crits) AS amount_crits, SUM(amount_overheal) AS amount_overheal, SUM(amount_absorbs) AS amount_absorbs, " +
									"SUM(num_total) AS num_total, SUM(num_hits) AS num_hits, SUM(num_crits) AS num_crits, SUM(num_overheals) AS num_overheals, SUM(num_absorbs) AS num_absorbs",
							:conditions => attr[:conditions],
							:joins => [ :source, :spell ],
							:order => "amount_total DESC",
							:group => "source_id, spell_id" })
	end

	def SegmentHeal.done_targets(attr = {})

		source_t = "units"
		dest_t = "dests_segment_heals"

    attr[:conditions] ||= {}
    attr[:conditions]['source_id'] = attr[:source_id] if attr.has_key?(:source_id)
    attr[:conditions]['units.is_player'] = attr[:is_player] if attr.has_key?(:is_player)
    attr[:conditions]['units.is_npc'] = attr[:is_npc] if attr.has_key?(:is_npc)
		attr[:conditions]['segment_id'] = attr[:segments] if attr.has_key?(:segments)

		self.find(:all, {
							:select =>
									"DISTINCT(source_id) AS source_id, #{source_t}.name AS source_name, #{source_t}.npc_id AS source_npc_id, #{source_t}.class_id AS source_class_id, " +
									"dest_id, #{dest_t}.name AS dest_name, #{dest_t}.npc_id AS dest_npc_id, #{dest_t}.class_id AS dest_class_id, " +
									"SUM(amount_total) AS amount_total, SUM(amount_hits) AS amount_hits, SUM(amount_crits) AS amount_crits, SUM(amount_overheal) AS amount_overheal, SUM(amount_absorbs) AS amount_absorbs, " +
									"SUM(num_total) AS num_total, SUM(num_hits) AS num_hits, SUM(num_crits) AS num_crits, SUM(num_overheals) AS num_overheals, SUM(num_absorbs) AS num_absorbs",
							:conditions => attr[:conditions],
							:joins => [ :source, :dest ],
							:order => "amount_total DESC",
							:group => "source_id, dest_id" })
	end

	def SegmentHeal.taken(attr = {})

		dest_t = "units"

    attr[:conditions] ||= {}
    attr[:conditions]['units.is_player'] = attr[:player] if attr[:player]
    
		self.find(:all, {
							:select => "DISTINCT(dest_id) AS dest_id, #{dest_t}.name as dest_name, #{dest_t}.class_id AS dest_class_id, SUM(amount_total) AS amount_total, SUM(amount_overheal) AS amount_overheal, SUM(num_total) AS num_total", #, (#{scope}s.finished_at - #{scope}s.started_at) AS duration",
							:conditions => attr[:conditions],
							:joins => [ :dest ],
							:order => "amount_total desc",
							:group => :dest_id })
	end

	def before_save
		self.amount_total = self.amount_hits + self.amount_crits
		self.num_total = self.num_hits + self.num_crits
	end
	
end
