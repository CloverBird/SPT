class Ingredient
  attr_reader :name, :unit, :calories_per_unit

  def initialize(name, unit, calories_per_unit)
    @name = name
    @unit = unit
    @calories_per_unit = calories_per_unit
  end
end