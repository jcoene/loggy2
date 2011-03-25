namespace :wow do

	desc "Import a logfile to a new report"
	task :import => :environment do
		
		ActiveRecord::Base.logger.level = 1
		
		filename, label, guild_id, user_id = ENV['file'], ENV['label'], ENV['guild'], ENV['user']
		usage "rake wow:import file=(filename) label=(label)" if not filename or not label
		fatal "No such file!" if !filename or !File.file?(filename)
		log = Wow::Importer.new(filename)
		fatal "Couldn't import log!" if !log.parse_text_to_new_report(:label => label, :user_id => user_id, :guild_id => guild_id)
	end
	
	desc "Import a gzipped logfile to a new report"
	task :importgz => :environment do
		
		ActiveRecord::Base.logger.level = 1

		filename, label, guild_id, user_id = ENV['file'], ENV['label'], ENV['guild'], ENV['user']
		usage "rake wow:importgz file=(filename) label=(label)" if not filename or not label
		fatal "No such file!" if !filename or !File.file?(filename)
		fatal "Not a gzip!" if not filename =~ /gz$/
		log = Wow::Importer.new(filename)
		fatal "Couldn't import log!" if !log.parse_gz_to_new_report(:label => label, :user_id => user_id, :guild_id => guild_id)
	end
	
	
	desc "Delete an existing report"
	task :delete => :environment do
		
		ActiveRecord::Base.logger.level = 1
		
		id = ENV['id']
		usage "rake wow:delete id=(id)" if not id or not id =~ /\d+/
		del = Wow::Deleter.new(id)
		fatal "Couldn't delete report" if !del.delete_report
	end

end

def usage(what)
	print "\n  Usage: %s\n" % what
	exit
end
def moan(what)
	print "%2d:%2d:%2d: %s\n" % [Time.now.hour, Time.now.min, Time.now.sec, what]
end

def fatal(why)
	print "Fatal error: %s\n" % why
	exit
end


=begin
			start = Time.now
			n=0
			log.events do |e|
				n += 1
				moan "%s > %s" % [e.source.to_s, e.dest.to_s]
				break if n > 5
			end

			done = Time.now
			sec = (done-start).ceil
			persec = (n/sec).ceil

			moan "Processed %d lines in %d sec, %d lines/sec" % [n, sec, persec]
=end
