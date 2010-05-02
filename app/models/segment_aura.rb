class SegmentAura < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	belongs_to :segment
	belongs_to :source, :class_name => "Unit"
	belongs_to :dest, :class_name => "Unit"
	belongs_to :spell
	
	# Applies a new aura, starting the clock (if necessary) and adding a gain
	def aura_apply(t, s=1)
		if not @gained then
			@gained = t
			self.num_gained += 1
		end
		@stacks = s
		self.num_stacks_max = s if s > self.num_stacks_max
	end

	# Removes an aura, stopping the clock and adding a loss
	def aura_remove(t)
		self.aura_close(t)
		self.num_lost += 1
	end

	# Resets an aura to defaults after a segment change
	def aura_reset
		self.aura_duration = self.num_gained = self.num_lost = self.num_stacks_max = 0
	end

	# Open an aura as-of a given time.  Used to open an aura at a segment change
	def aura_open(t, s=1)
		@gained = t
		@stacks = s
		self.num_stacks_max = s
	end

	# Close an aura as-of a given time.  Used to close open auras at the end of an encounter
	def aura_close(t)
		return if not @gained
		self.aura_duration += Timespan.to_i(@gained, t)
		@gained = nil
		@stacks = nil
	end

	# Returns true if this aura is open
	def open?
		true if @gained
	end

	def current_stacks
		@stacks
	end

	def SegmentAura.gained(attr = {})
		source_t = "units"
		dest_d = "dests_segment_auras"

    attr[:conditions] ||= {}
    attr[:conditions]['dests_segment_auras.is_player'] = attr[:is_player]

		self.find(:all, {
							:select => "DISTINCT(dest_id) AS dest_id, #{dest_d}.name AS dest_name, #{dest_d}.class_id AS dest_class_id, source_id, #{source_t}.name AS source_name, #{source_t}.class_id AS source_class_id, spell_id, spells.name AS spell_name, spells.school AS spell_school, aura_type, SUM(aura_duration) AS aura_duration, SUM(num_gained) AS num_gained, SUM(num_lost) AS num_lost, num_stacks_max", #, (#{scope}s.finished_at - #{scope}s.started_at) AS duration",
							:conditions => attr[:conditions],
							:joins => [ :source, :dest, :spell ],
							:order => "dest_name ASC, aura_duration DESC",
							:group => "dest_id, spell_id" })
	end

end
