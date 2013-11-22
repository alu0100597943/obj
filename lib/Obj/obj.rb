class Obj

	def initialize(mode,*args)
		@args = {}
		args.each do |var|
			@args["#{var}"] = "not assigned"
			if(mode == "writer")
				self.class.class_eval Obj.create_setter(var)
			elsif(mode == "reader")
				self.class.class_eval Obj.create_getter(var)
			elsif(mode == "accessor")
				self.class.class_eval Obj.create_setter(var)
				self.class.class_eval Obj.create_getter(var)
			end
		end
	end

	def attributes
		out = "Attributes{\n"
		@args.each do |var|
			out << "\t#{var[0]}: #{var[1]}\n"
		end
		out << "}\n"
		out
	end

	def members
		out = "["
		@args.each do |var|
			out << ":#{var[0]} "
		end
		out << "]"
		out
	end

	def self.create_setter(var)
		out = "def #{var}=(value)\n"
		out << "@args[\"#{var}\"] = value\n"
		out << "end"
		out
	end

	def self.create_getter(var)
		out = "def #{var}\n"
		out << "@args[\"#{var}\"]\n"
		out << "end"
		out
	end

	def method_missing(meth, *value)
		#puts "Warning: Method  not defined:\t'#{meth}'"
		if(value.length == 1)
			newname = meth.to_s.gsub(/\=/,"")
			@args["#{newname}"] = value[0]
			self.class.class_eval Obj.create_setter(newname)
		else
			self.class.class_eval Obj.create_getter(meth)
			@args["#{meth}"]
		end
	end

end

if __FILE__ == $0
	matriz = Obj.new("accessor")

	puts matriz.members
	puts matriz.attributes

	matriz.fil = 3
	matriz.col = 5
	matriz.content = [[1,2,3,4,5],[1,2,3,4,5],[1,2,3,4,5]]


	puts matriz.members
	puts matriz.attributes

	puts "Numero de filas: #{matriz.fil}"
	puts "Numero de columnas: #{matriz.col}"
	puts "Matriz: #{matriz.content}"
end