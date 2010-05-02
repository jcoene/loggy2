class Spell < ActiveRecord::Base
	has_many :events
	has_many :segment_damages
	has_many :segment_heals

	def to_i; self.id; end
	def to_s; self.name; end

	def html_class
		Spell.html_class self.school
	end

	def school_name
		Spell.school_name self.school
	end

	def Spell.html_class(s)
		"spell s_%s" % Spell.school_name(s)
	end
	
	def Spell.school_name(s)
		case s.to_i
			when SCHOOL_PHYSICAL
				"physical"
			when SCHOOL_HOLY
				"holy"
			when SCHOOL_FIRE
				"fire"
			when SCHOOL_NATURE
				"nature"
			when SCHOOL_FIRESTORM
				"firestorm"
			when SCHOOL_FROST
				"frost"
			when SCHOOL_FROSTFIRE
				"frostfire"
			when SCHOOL_FROSTSTORM
				"froststorm"
			when SCHOOL_SHADOW
				"shadow"
			when SCHOOL_SHADOWSTORM
				"shadowstorm"
			when SCHOOL_SHADOWFROST
				"shadowfrost"
			when SCHOOL_ARCANE
				"arcane"
			when SCHOOL_SPELLFIRE
				"spellfire"
			else
				"physical"
		end
	end
	
	def Spell.aura_type(a)
		case a
			when AURA_BUFF
				"buff"
			when AURA_DEBUFF
				"debuff"
			else
				"other"
		end
	end

	private

	def attributes_protected_by_default
    []
  end

end
