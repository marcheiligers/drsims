# Circle
# used as a head for ragdolls
class Circle
  attr_sprite
  attr_accessor :radius, :attached_point_mass

  def initialize(r)
    @radius = r
  end

  # Constraints
  def solve_constraints
    x = attached_point_mass.x
    y = attached_point_mass.y

    # only do a boundary constraint
    y = 2 * @radius - y if y < @radius
    y = 2 * (HEIGHT - @radius) - y if y > HEIGHT - @radius
    x = 2 * (WIDTH - @radius) - x if x > WIDTH - @radius
    x = 2 * @radius - x if x < @radius

    attached_point_mass.x = x
    attached_point_mass.y = y
  end

  def draw_override(ffi)
    r = @radius * 2
    ffi.draw_sprite attached_point_mass.x, attached_point_mass.y, r, r, 'sprites/circle/white.png'
  end

  def attach_to_point_mass(p)
    @attached_point_mass = p
  end
end
