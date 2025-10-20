require_relative "ingredient"
require_relative "recipe"
require_relative "recipe_item"
require_relative "unit_converter"
require_relative "pantry"
require_relative "planner"

# create ingredients
flour = Ingredient.new('борошно', :g, 3.64)
milk  = Ingredient.new('молоко',  :ml, 0.06)
egg   = Ingredient.new('яйце',    :pcs, 72.0)
pasta = Ingredient.new('паста',   :g, 3.5)
sauce = Ingredient.new('соус',    :ml, 0.2)
cheese= Ingredient.new('сир',     :g, 4.0)

# recipes
omelet = Recipe.new('Омлет', ['Змішати', 'Посмажити'], [
  RecipeItem.new(egg,   3,   :pcs),
  RecipeItem.new(milk,  100, :ml),
  RecipeItem.new(flour, 20,  :g),
])

pasta_dish = Recipe.new('Паста', ['Зварити пасту', 'Додати соус і сир'], [
  RecipeItem.new(pasta, 200, :g),
  RecipeItem.new(sauce, 150, :ml),
  RecipeItem.new(cheese,50,  :g),
])

# pantry
pantry = Pantry.new
pantry.add('борошно', 1,   :kg)
pantry.add('молоко',  0.05, :l)
pantry.add('яйце',    2,   :pcs)
pantry.add('паста',   300, :g)
pantry.add('сир',     150, :g)

# prices
prices = {
  'борошно' => 0.02,
  'молоко'  => 0.015,
  'яйце'    => 6.0,
  'паста'   => 0.03,
  'соус'    => 0.025,
  'сир'     => 0.08
}

Planner.plan([omelet, pasta_dish], pantry, prices)