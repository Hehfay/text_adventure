class Character

  attr_reader :character_name,
              :health,
              :strength,
              :endurance,

              :attack_rating,
              :armor_rating,

              :level,
              :experience,

              :gold,
              :fame,
              :infamy,

              :inventory

  public

  def initialize(saved_data)
    set_name(name)
  end

  def deal_damage
  end

  def take_damage(amount)
  end

  def use_item
  end

  def show_attributes
    # Return character information
    # in array or hash.
  end

  def talk
  end

  private

  def set_name(name)
    @name = name
  end

end
