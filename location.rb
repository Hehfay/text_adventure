class Location

  require_relative 'character'

  attr_accessor :location_name,
                :location_type

  def initialize(name, type)
    @location_name = name
    @location_type = type
  end

  def def main(main_character)
    # The main event loop for the location
    # will go here. An instance of the player class should
    # be passed in and returned as the main player acts in
    # a location.  This method will be over written in every
    # child of this class.
  end

end