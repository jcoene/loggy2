require 'zlib'

class Wow

	class Deleter
		
		def initialize(id)
			@id = id
		end
		
		def delete_report
			r = Report.find_by_id(@id)
			return false if r.blank?
			
			r.destroy
		end
	end
	
	class Importer
		
		def initialize(filename)
			@filename = filename
		end

		# parse_text_to_new_report (attributes) => nil
		#
		# Parses the log file to a new report
		#
		def parse_text_to_new_report(attr)
			r = Report.new(attr)
			r.save
			
			r.preload_defaults
			r.preload_spells

			p "Creating new report: #{r.id}, #{r.label}"

			File.open(@filename, "r") do |f|
				while (line = f.gets)
					r.parse_log line
				end
				r.parse_complete
			end
			true
		end
		
		# parse_gz_to_new_report (attributes) => nil
		#
		# Parses the gzipped log file to a new report
		#
		def parse_gz_to_new_report(attr)
			r = Report.new(attr)
			r.save
			
			r.preload_defaults
			r.preload_spells

			p "Creating new report: #{r.id}, #{r.label}"

			Zlib::GzipReader.open(@filename) do |f|
				while (line = f.gets)
					r.parse_log line
				end
				r.parse_complete
			end
			true
		end
	
	end
end