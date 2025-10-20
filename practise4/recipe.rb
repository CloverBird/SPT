class Recipe
  attr_reader :name, :steps, :items

  def initialize(name, steps, items)
    @name = name
    @steps = steps
    @items = items
  end

  def need
    need_items_base = Hash.new {|h, k| h[k] = { quantity: 0.0, unit: nil } }
    @items.each do |item|
      key = item.ingredient.name
      UnitConverter.ensure_compatible_units!(item.unit, item.ingredient.unit)

      quantity = UnitConverter.to_base(item.quantity, item.unit)
      base_unit = UnitConverter.base_unit_name(item.unit)

      element = need_items_base[key]
      element[:unit] ||= base_unit
      element[:quantity] += quantity
    end
    need_items_base
  end
end