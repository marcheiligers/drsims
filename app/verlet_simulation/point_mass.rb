class PointMass
  attr_sprite
  attr_accessor :x, :y, :mass
  attr_reader :links

  # PointMass constructor
  def initialize(x, y)
    @mass = 1
    @links = []
    @pinned = false

    @x = x
    @y = y

    @last_x = x
    @last_y = y
  end

  # The update function is used to update the physics of the PointMass.
  # motion is applied, and links are drawn here
  def update(mouse_x, mouse_y, pmouse_x, pmouse_y, button_left, button_right, gravity)
    vel_x = (@x - @last_x) * 0.99
    vel_y = (@y - @last_y) * 0.99

    # calculate the next position using Verlet Integration
    next_x = @x + vel_x + 0.5 * (0 / @mass) * FIXED_DELTA_TIME_SECONDS_SQ
    next_y = @y + vel_y + 0.5 * gravity * FIXED_DELTA_TIME_SECONDS_SQ

    # reset variables
    @last_x = @x
    @last_y = @y

    @x = next_x
    @y = next_y

    # this is where our interaction comes in.
    if button_left || button_right
      distance_squared = dist_point_to_segment_squared(pmouse_x, pmouse_y, mouse_x, mouse_y, @x, @y)
      if button_left
        # if distance_squared < $sim.mouse_influence_size #  remember mouseinfluencesize was squared in setup()
        if distance_squared < MOUSE_INFLUENCE_SIZE #  remember mouseinfluencesize was squared in setup()
          # To change the velocity of our PointMass, we subtract that change from the lastPosition.
          # When the physics gets integrated (see updatePhysics()), the change is calculated
          # Here, the velocity is set equal to the cursor's velocity
          @last_x = @x - (mouse_x - pmouse_x) * MOUSE_INFLUENCE_SCALAR
          @last_y = @y - (mouse_y - pmouse_y) * MOUSE_INFLUENCE_SCALAR
        end
      elsif distance_squared < MOUSE_TEAR_SIZE # if the right mouse button is clicking, we tear the cloth by removing links
        links.clear
      end
    end
  end

  # Using http://www.codeguru.com/forum/showpost.php?p=1913101&postcount=16
  # We use this to have consistent interaction
  # so if the cursor is moving fast, it won't interact only in spots where the applet registers it at
  def dist_point_to_segment_squared(linex1, liney1, linex2, liney2, pointx, pointy)
    vx = linex1 - pointx
    vy = liney1 - pointy
    ux = linex2 - linex1
    uy = liney2 - liney1

    len = ux * ux + uy * uy
    det = (-vx * ux) + (-vy * uy)
    if (det < 0) || (det > len)
      ux = linex2 - pointx
      uy = liney2 - pointy
      return [vx * vx + vy * vy, ux * ux + uy * uy].min
    end

    det = ux * vy - uy * vx
    (det * det) / len
  end

  def draw_override(ffi)
    l = @links.size
    if l > 0
      i = 0
      while i < l
        @links[i].draw(ffi)
        i += 1
      end
    else
      ffi.draw_solid_2 @x, @y, 1, 1, 0, 0, 0, 255, 1
    end
  end

  # Constraints
  def solve_constraints
    # Link Constraints
    # Links make sure PointMasss connected to this one is at a set distance away
    l = @links.size
    i = 0
    while i < l
      link = @links[i]
      @links[i].solve if link
      i += 1
    end

    if @pinned
      # Other Constraints
      # make sure the PointMass stays in its place if it's pinned
      @x = @pin_x
      @y = @pin_y
    else
      # Boundary Constraints
      # These if statements keep the PointMasss within the screen
      @y = 2 - @y if @y < 1
      # @y = 2 * ($sim.height - 1) - y if y > $sim.height - 1
      @y = 2 * (HEIGHT - 1) - @y if @y > HEIGHT - 1

      # @x = 2 * ($sim.width - 1) - x if x > $sim.width - 1
      @x = 2 * (WIDTH - 1) - @x if @x > WIDTH - 1
      @x = 2 - @x if @x < 1
    end
  end

  # attachTo can be used to create links between this PointMass and other PointMasss
  def attach_to(point_mass, resting_dist, stiff, tear_sensitivity = 30, draw_link = true)
    lnk = Link.new(self, point_mass, resting_dist, stiff, tear_sensitivity, draw_link)
    @links.push(lnk)
  end

  def remove_link(lnk)
    @links.delete(lnk)
  end

  def pin_to(px, py)
    @pinned = true
    @pin_x = px
    @pin_y = py
  end
end
