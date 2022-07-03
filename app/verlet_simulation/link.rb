# The Link class is used for handling distance constraints between PointMasss.
class Link
  attr_reader :resting_distance, :stiffness, :tear_sensitivity, :p1, :p2, :draw_this

  def initialize(which1, which2, resting_dist, stiff, tear_sensitivity, draw_me = true)
    @p1 = which1; # when you set one object to another, it's pretty much a reference.
    @p2 = which2; # Anything that'll happen to p1 or p2 in here will happen to the paticles in our ArrayList

    @resting_distance = resting_dist
    @stiffness = stiff
    @draw_this = draw_me

    @tear_sensitivity = tear_sensitivity

    # Inverse the mass quantities
    im1 = 1 / @p1.mass
    im2 = 1 / @p2.mass
    @scalar_p1 = (im1 / (im1 + im2)) * @stiffness
    @scalar_p2 = @stiffness - @scalar_p1
  end

  # Solve the link constraint
  def solve
    result = Verlet_solve(@p1.x.to_f, @p1.y.to_f, @p2.x.to_f, @p2.y.to_f,
                       @tear_sensitivity.to_f, @resting_distance.to_f,
                       @scalar_p1.to_f, @scalar_p2.to_f)
puts "#{tear_sensitivity} --> #{result.rm}"
    @p1.remove_link(self) if result.rm == 1
    @p1.x = result.p1x
    @p1.y = result.p1y
    @p2.x = result.p2x
    @p2.y = result.p2y

    # # calculate the distance between the two PointMasss
    # diffx = @p1.x - @p2.x
    # diffy = @p1.y - @p2.y
    # d = Math.sqrt(diffx * diffx + diffy * diffy)

    # # if the distance is more than curtainTearSensitivity, the cloth tears
    # @p1.remove_link(self) if d > @tear_sensitivity

    # # find the difference, or the ratio of how far along the restingDistance the actual distance is.
    # difference = (@resting_distance - d) / d

    # # Push/pull based on mass
    # # heavier objects will be pushed/pulled less than attached light objects
    # @p1.x += diffx * @scalar_p1 * difference
    # @p1.y += diffy * @scalar_p1 * difference

    # @p2.x -= diffx * @scalar_p2 * difference
    # @p2.y -= diffy * @scalar_p2 * difference
  end

  def draw(ffi)
    ffi.draw_line_2 @p1.x, @p1.y, @p2.x, @p2.y, 0, 0, 0, 255, 1 if @draw_this
  end
end
