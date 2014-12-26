class Player < Character

	attr_reader :name, 
							:health, 
							:strength, 
							:endurance,

							:armor_rating, 
							:attack_rating,

							:level,
							:experience,
							:location,

							:gold,
							:fame,
							:infamy

	public

	def initialize(name)
		# Initialize will need to set starting values
		# if starting a new game. Else it will need
		# to read values from a file using class Crud
		# (loading a saved game).
	end

	def deal_damage
	end

	def take_damage
	end

	def equip(item)
	end

	def use(item)
	end

	def show_attributes
		# Return character information
		# in array or hash.
	end

	private

	def level_up
		# Health, strength, endurance, level,
		# and experience attributes will 
		# be modified here.
	end

end
