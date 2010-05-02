class Guild < ActiveRecord::Base
	has_many :reports
	has_many :encounters
	
end
