class Encounter < ActiveRecord::Base
	belongs_to :guild
	belongs_to :report
	belongs_to :boss
	has_many :segments
	has_many :events
  has_many :auras, :class_name => "SegmentAura"
  has_many :damages, :class_name => "SegmentDamage"
  has_many :deaths, :class_name => "SegmentDeath"
  has_many :dispels, :class_name => "SegmentDispel"
  has_many :gains, :class_name => "SegmentGain"
  has_many :heals, :class_name => "SegmentHeal"
  has_many :interrupts, :class_name => "SegmentInterrupt"
  has_many :steals, :class_name => "SegmentSteal"

	def result_name
		Encounter.result_name(self.result_code)
	end

	def Encounter.result_name(result_code)
		case result_code
			when RESULT_SUCCESS
				"Success"
			when RESULT_FAILURE
				"Failed"
			else
				"Unknown"
		end
	end
end
