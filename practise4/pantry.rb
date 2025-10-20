class Pantry
  def initialize
    @store = Hash.new { |h, k| h[k] = { quantity: 0.0, unit: nil } }
  end

  def add(name, qty, unit)
    base_qty  = UnitConverter.to_base(qty, unit)
    base_unit = UnitConverter.base_unit_name(unit)

    item = @store[name]
    item[:unit] ||= base_unit
    raise "Unit mismatch for pantry item #{name}" if item[:unit] != base_unit
    item[:quantity]  += base_qty
  end

  def available_for(name)
    (!@store[name].nil? && !@store[name][:quantity].nil?) ? @store[name][:quantity] : 0.0
  end
end