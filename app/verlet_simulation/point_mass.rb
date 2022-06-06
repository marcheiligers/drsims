class PointMass
  attr_accessor :last_x, :last_y # for calculating position change (velocity)
  attr_accessor :x, :y
  attr_accessor :acc_x, :acc_y

  attr_accessor :mass
  attr_accessor :damping

  # An ArrayList for links, so we can have as many links as we want to this PointMass
  attr_accessor :links

  attr_accessor :pinned
  attr_accessor :pin_x, :pin_y

  # TODO: these umm, yeah
  attr_accessor :pmouse_x, :pmouse_y

  # PointMass constructor
  def initialize(x, y)
    @mass = 1
    @damping = 20
    @links = []
    @pinned = false

    @x = x
    @y = y

    @last_x = x
    @last_y = y

    @acc_x = 0
    @acc_y = 0

    @pmouse_x = 0
    @pmouse_y = 0
  end

  # The update function is used to update the physics of the PointMass.
  # motion is applied, and links are drawn here
  def update_physics(time_step) # time_step should be in elapsed seconds (deltaTime)
    apply_force(0, mass * $sim.gravity) # TODO: gravity is global???

    vel_x = x - last_x
    vel_y = y - last_y

    # dampen velocity
    vel_x *= 0.99
    vel_y *= 0.99

    time_step_sq = time_step * time_step

    # calculate the next position using Verlet Integration
    next_x = x + vel_x + 0.5 * acc_x * time_step_sq
    next_y = y + vel_y + 0.5 * acc_y * time_step_sq

    # reset variables
    @last_x = x
    @last_y = y

    @x = next_x
    @y = next_y

    @acc_x = 0
    @acc_y = 0
  end

  # TODO: this method is full of globals
  def update_interactions
    mouse_x = $args.inputs.mouse.x
    mouse_y = $args.inputs.mouse.y

    # this is where our interaction comes in.
    if $args.inputs.mouse.button_left || $args.inputs.mouse.button_right
      distance_squared = $sim.dist_point_to_segment_squared(pmouse_x, pmouse_y, mouse_x, mouse_y, x, y)
      if $args.inputs.mouse.button_left
        if distance_squared < $sim.mouse_influence_size #  remember mouseinfluencesize was squared in setup()
          # To change the velocity of our PointMass, we subtract that change from the lastPosition.
          # When the physics gets integrated (see updatePhysics()), the change is calculated
          # Here, the velocity is set equal to the cursor's velocity
          @last_x = x - (mouse_x - pmouse_x) * $sim.mouse_influence_scalar
          @last_y = y - (mouse_y - pmouse_y) * $sim.mouse_influence_scalar
        end
      else # if the right mouse button is clicking, we tear the cloth by removing links
        if distance_Squared < $sim.mouse_tear_size
          links.clear
        end
      end
    end

    @pmouse_x = mouse_x
    @pmouse_y = mouse_y
  end

  def draw
    # draw the links and points
    if links.size > 0
      links.each(&:draw)
    else
      point(x, y)
    end
  end

  # Constraints
  def solve_constraints
    # Link Constraints
    # Links make sure PointMasss connected to this one is at a set distance away
    links.each(&:solve)

    if pinned
      # Other Constraints
      # make sure the PointMass stays in its place if it's pinned
      @x = pin_x
      @y = pin_y
    else
      # Boundary Constraints
      # These if statements keep the PointMasss within the screen
      # TODO: height is global
      @y = 2 * (1) - y if y < 1
      @y = 2 * ($sim.height - 1) - y if y > $sim.height - 1

      # TODO: width is global
      @x = 2 * ($sim.width - 1) - x if x > $sim.width - 1
      @x = 2 * (1) - x if x < 1
    end
  end

  # attachTo can be used to create links between this PointMass and other PointMasss
  def attach_to(point_mass, resting_dist, stiff, tear_sensitivity = 30, draw_link = true)
    lnk = Link.new(self, point_mass, resting_dist, stiff, tear_sensitivity, draw_link)
    links.push(lnk)
  end

  def remove_link(lnk)
    links.delete(lnk)
  end

  def apply_force(fx, fy)
    # acceleration = (1/mass) * force
    # or
    # acceleration = force / mass
    @acc_x += fx / mass
    @acc_y += fy / mass
  end

  def pin_to(px, py)
    @pinned = true
    @pin_x = px
    @pin_y = py
  end
end
