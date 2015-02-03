# 12.25.2014
# TODO This class performs CRUD operations on a file.
# Eventually, this will need to be updated to store
# game data for text adventure, but this is a good
# start.
class Crud
	
	public

	def Crud.initialize(file_name)
		@file_name = file_name
		@record = {}
		update_hash if File.exists?(@file_name)  
	end

	def Crud.create(name, rating)
		if @record.has_key?(name.to_sym)
			"#{name} record already exists."
		else
			@record[name.to_sym] = rating.to_i
			update_file('a+')
			"#{name} #{rating} added."
		end
	end

	def Crud.read
		counter = 1
		@record.each do |key, value| 
			printf("%.2i %s %i\n", counter, key, value) 
			counter += 1
		end
	end

	def Crud.update(key, value)
		if @record.has_key?(key.to_sym)
			@record[key.to_sym] = value.to_i
			update_file
			'Update successful.'
		else
			"#{key} not found."
		end
	end

	def Crud.delete(key)
		if @record.has_key?(key.to_sym)
			@record.delete(key.to_sym)
			update_file
			'Delete successful.'
		else
			"#{key} not found."
		end
	end

	private

	def update_file(opening_mode = 'w')
		f = File.open(@file_name, opening_mode)
		@record.each { |key, value| f.puts "#{key} #{value}" }
		f.close
	end

	def update_hash
		f = File.open(@file_name, 'r')
			f.each_line do |line|
				word = line.split(' ')
				@record[word[0].to_sym] = word[1].to_i
			end
		f.close
	end

end
