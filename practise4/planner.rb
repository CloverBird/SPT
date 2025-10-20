class Planner
  def self.plan(recipes, pantry, price_list)
    total_need = Hash.new { |h, k| h[k] = { qty: 0.0, unit: nil } }

    recipes.each do |r|
      r.need.each do |name, data|
        total_need[name][:unit] ||= data[:unit]
        raise "Unit mismatch for #{name}" if total_need[name][:unit] != data[:unit]
        total_need[name][:qty]  += data[:quantity]
      end
    end

    ingredient_by_name = {}
    recipes.each do |r|
      r.items.each { |item| ingredient_by_name[item.ingredient.name] = item.ingredient }
    end

    total_calories = 0.0
    total_cost     = 0.0

    puts "Ingredient |  Need   |  Have   | Deficit | Unit"
    puts "-----------------------------------------------"

    total_need.each do |name, data|
      need_qty = data[:qty]
      unit     = data[:unit] #|| UnitConverter.base_unit_name(:pcs)
      have_qty = pantry.available_for(name)
      deficit  = [need_qty - have_qty, 0.0].max

      cals_per_unit = ingredient_by_name[name]&.calories_per_unit || 0.0
      price_per_unit = price_list[name] || 0.0

      total_calories += need_qty * cals_per_unit
      total_cost     += deficit  * price_per_unit

      puts "#{name.ljust(10)} | #{format('%.2f', need_qty).rjust(7)} | "\
             "#{format('%.2f', have_qty).rjust(7)} | #{format('%.2f', deficit).rjust(7)} | #{unit}"
    end

    puts "-" * 54
    puts "total_calories: #{format('%.2f', total_calories)}"
    puts "total_cost:     #{format('%.2f', total_cost)}"
  end
end