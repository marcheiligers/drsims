# Circle
# used as a head for ragdolls
class Circle
  attr_accessor :radius, :attached_point_mass

  def initialize(r)
    @radius = r
  end

  # Constraints
  def solve_constraints
    x = attached_point_mass.x
    y = attached_point_mass.y

    # only do a boundary constraint
    # TODO: width and height is global
    y = 2 * radius - y if y < radius
    y = 2 * ($sim.height - radius) - y if y > $sim.height - radius
    x = 2 * ($sim.width - radius) - x if x > $sim.width - radius
    x = 2 * radius - x if x < radius

    attached_point_mass.x = x
    attached_point_mass.y = y
  end

  def draw
    ellipse(attached_point_mass.x, attached_point_mass.y, radius * 2, radius * 2)
  end

  def attach_to_point_mass(p)
    @attached_point_mass = p
  end
end
