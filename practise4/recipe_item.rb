class RecipeItem
  attr_reader :ingredient, :quantity, :unit

  def initialize(ingredient, quantity, unit)
    @ingredient = ingredient
    @quantity = quantity
    @unit = unit
  end
end