class Array
	def to_integers
		self.collect {|x| x.to_i }
	end
	def to_integers!
		self.collect! {|x| x.to_i }
	end
end

class Uptime
	def Uptime.percent(val, inval = 1, p=0)
		(val.to_f / (inval.to_f || 1.0) * 100).to_i.pretty.to_s << "%"
	end
end

def is_integer(value)
	return value =~ /^\d+$/
end

def is_boolean(value)
	return [true, false, "true", "T", "t", "yes", "Y", "y", "1", 1, "false", "F", "f", "no", "N", "n", "0", 0].include?(value.class == String ? value.downcase : value)
end

def to_boolean(value)
	return [true, "true", "T", "t", "yes", "Y", "y", "1", 1].include?(value.class == String ? value.downcase : value)
end

def string_to_array(value)
	return value.split(',') || []
end

def string_is_array(value)
	return value =~ /^\d+(,\d+)*$/
end

class Timespan

	def Timespan.to_f(to, from); ts = Timespan.new(to, from); ts.to_f; end
	def Timespan.to_i(to, from); ts = Timespan.new(to, from); ts.to_i; end
	def Timespan.to_s(to, from); ts = Timespan.new(to, from); ts.to_s; end
	def Timespan.to_clock(to, from); ts = Timespan.new(to, from); ts.to_clock; end

	def initialize(from, to)
		@from, @to = from, to
	end

	def to_f
		(@to.to_i - @from.to_i).to_f
	end

	def to_i
		@to.to_i - @from.to_i
	end

	def to_s
		diff = @to.to_i - @from.to_i
		str = ""
		if diff > (60*60) then
			h = (diff/3600).floor
			diff -= (h*3600)
			str << "%dh " % h
		end
		if diff > (60) then
			m = (diff/60).floor
			diff -= (m*60)
			str << "%dm " % m
		end
		if diff > 0 then
			str << "%ds" % diff
		end
		str
	end

	def to_clock
		diff = @to.to_i - @from.to_i
		str = ""
		if diff > (60*60) then
			h = (diff/3600).floor
			diff -= (h*3600)
			str << "%02d:" % h
		end
		if diff > (60) then
			m = (diff/60).floor
			diff -= (m*60)
			str << "%02d:" % m
		end
		str << "%02d" % diff.to_i
		str
	end
end

class String

  def unquote
    self.gsub(/^"(.*?)"$/,'\1')
	end
	def quote
		"\"%s\"" % self
	end

	def slug
		str = String.new(self)
		str.gsub!(/&/, 'and')
		str.gsub!(/!/, '')
		str.gsub!(/'/, '')
		str.gsub!(/"/, '')
		str.gsub!(/\%/, '_percent')
		str.gsub!(/[^\w_-]+/i, '_')
		str.gsub!(/\-{2,}/i, '_')
		str.gsub!(/^\-|\-$/i, '')
		str.downcase!
		str
	end
end

class Fixnum
	def pretty
		self.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
	end
end

def Time.parse_wow(str)
	begin
		/(\d{1,2})\/(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})\.(\d{1,3})/ =~ str
		month, day, hour, min, sec, usec = $~[1..6]
		Time.local(Time.now.year, month, day, hour, min, sec, usec)
	rescue
		false
	end
end