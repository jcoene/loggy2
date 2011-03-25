class Boss < ActiveRecord::Base
	belongs_to :zone
	has_many :encounters
end
