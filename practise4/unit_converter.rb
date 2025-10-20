class UnitConverter
  MASS_UNITS = { g: 1, kg: 1000 }
  VOLUME_UNITS = { ml: 1, l: 1000 }
  PCS_UNITS = { pcs: 1 }

  def self.to_base(qty, unit)
    qty * to_base_unit(unit)
  end

  def self.to_base_unit(unit)
    if MASS_UNITS.key?(unit)
      MASS_UNITS[unit]
    elsif VOLUME_UNITS.key?(unit)
      VOLUME_UNITS[unit]
    elsif PCS_UNITS.key?(unit)
      PCS_UNITS[unit]
    else
      raise "Unknown unit: #{unit}"
    end
  end

  # forbid converting between different units family
  def self.ensure_compatible_units!(unit1, unit2)
    unit_family1 = base_unit_name(unit1)
    unit_family2 = base_unit_name(unit2)
    raise "Incompatible units: #{unit1} vs #{unit2}" if unit_family1 != unit_family2
  end

  def self.base_unit_name(unit)
    return :g  if MASS_UNITS.key?(unit)
    return :ml   if VOLUME_UNITS.key?(unit)
    return :pcs   if PCS_UNITS.key?(unit)
    raise "Unknown unit: #{unit}"
  end

  private_class_method :to_base_unit
end