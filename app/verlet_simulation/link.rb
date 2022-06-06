# The Link class is used for handling distance constraints between PointMasss.
class Link
  attr_accessor :resting_distance
  attr_accessor :stiffness
  attr_accessor :tear_sensitivity

  attr_accessor :p1
  attr_accessor :p2

  # if you want this link to be invisible, set this to false
  attr_accessor :draw_this

  def initialize(which1, which2, resting_dist, stiff, tear_sensitivity, draw_me = true)
    @p1 = which1; # when you set one object to another, it's pretty much a reference.
    @p2 = which2; # Anything that'll happen to p1 or p2 in here will happen to the paticles in our ArrayList

    @resting_distance = resting_dist
    @stiffness = stiff
    @draw_this = draw_me

    @tear_sensitivity = tear_sensitivity
  end

  # Solve the link constraint
  def solve
    # calculate the distance between the two PointMasss
    diffx = p1.x - p2.x
    diffy = p1.y - p2.y
    d = Math.sqrt(diffx * diffx + diffy * diffy)

    # find the difference, or the ratio of how far along the restingDistance the actual distance is.
    difference = (resting_distance - d) / d

    # if the distance is more than curtainTearSensitivity, the cloth tears
    p1.remove_link(self) if d > tear_sensitivity

    # Inverse the mass quantities
    im1 = 1 / p1.mass
    im2 = 1 / p2.mass
    scalar_p1 = (im1 / (im1 + im2)) * stiffness
    scalar_p2 = stiffness - scalar_p1

    # Push/pull based on mass
    # heavier objects will be pushed/pulled less than attached light objects
    p1.x += diffx * scalar_p1 * difference
    p1.y += diffy * scalar_p1 * difference

    p2.x -= diffx * scalar_p2 * difference
    p2.y -= diffy * scalar_p2 * difference
  end

  # Draw if it's visible
  def draw
    return unless draw_this

    line(p1.x, p1.y, p2.x, p2.y)
  end
end
