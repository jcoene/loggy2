class Unit < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	has_many :events
	has_many :segment_damages
	has_many :segment_heals

	before_validation :update_flags

	validates_presence_of :npc_id
	validates_uniqueness_of :id
	validates_uniqueness_of :guid, :scope => :report_id
	
	def to_i; self.id; end
	def to_s; self.name; end
	
	def update_flags
		self.is_player = self.player? || false
		self.is_pet = (self.pet? or self.guardian?) || false
		self.is_npc = self.npc? || false
		self.npc_id = self.source_guid[8..11].to_i(16) if not self.is_player
		self.npc_id ||= 0
		true
	end

	def exists?; not self.source_guid == UNIT_GUID_NONE; end
	#def player?; (self.flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_PLAYER; end
	def player?; self.guid =~ /^0x/ and self.guid[4..4].to_s == "0"; end
	def vehicle?; (self.flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_OBJECT and (self.flags.to_i(16) & OBJECT_CONTROL_MASK) == OBJECT_CONTROL_PLAYER; end
	def pet?; (self.flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_PET; end
	def guardian?; (self.flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_GUARDIAN; end
	def object?; (self.flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_OBJECT; end
	def npc?; (self.flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_NPC; end
	def friendly?; (self.flags.to_i(16) & OBJECT_REACTION_MASK) == OBJECT_REACTION_FRIENDLY; end
	def hostile?; (self.flags.to_i(16) & OBJECT_REACTION_MASK) == OBJECT_REACTION_HOSTILE; end
	def neutral?; (self.flags.to_i(16) & OBJECT_REACTION_MASK) == OBJECT_REACTION_FRIENDLY; end

	def Unit.guid_is_a_player(guid); guid =~ /^0x/ and guid[4..4].to_s == "0"; end
	def Unit.flags_is_a_player(flags); (flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_PLAYER; end
	def Unit.flags_is_a_pet(flags); (flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_PET; end
	def Unit.flags_is_a_guardian(flags); (flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_GUARDIAN; end
	def Unit.flags_is_an_npc(flags); (flags.to_i(16) & OBJECT_TYPE_MASK) == OBJECT_TYPE_NPC; end

	def html_class
		Unit.html_class self.class_id
	end

	def class_name
		Unit.class_name self.class_id
	end

	def Unit.html_class(s)
		"unit player p_%s" % Unit.class_name(s)
	end

	def Unit.class_name(id)
		classes = ["", "warrior", "paladin", "hunter", "rogue", "priest", "deathknight", "shaman", "mage", "warlock", "", "druid"]
		classes[id.to_i] || ""
	end

end