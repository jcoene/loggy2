class Segment < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	has_many :events
  has_many :auras, :class_name => "SegmentAura"
  has_many :damages, :class_name => "SegmentDamage"
  has_many :deaths, :class_name => "SegmentDeath"
  has_many :dispels, :class_name => "SegmentDispel"
  has_many :gains, :class_name => "SegmentGain"
  has_many :heals, :class_name => "SegmentHeal"
  has_many :interrupts, :class_name => "SegmentInterrupt"
  has_many :steals, :class_name => "SegmentSteal"

end
