class SegmentGain < ActiveRecord::Base
	belongs_to :report
	belongs_to :encounter
	belongs_to :segment
	belongs_to :source, :class_name => "Unit"
	belongs_to :dest, :class_name => "Unit"
	belongs_to :spell
	
end
