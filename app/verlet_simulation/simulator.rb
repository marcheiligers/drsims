# https://gamedevelopment.tutsplus.com/tutorials/simulate-tearable-cloth-and-ragdolls-with-simple-verlet-integration--gamedev-519
class Simulator
  # Where we'll store all of the points
  attr_accessor :pointmasses

  # every PointMass within this many pixels will be influenced by the cursor
  attr_accessor :mouse_influence_size
  # minimum distance for tearing when user is right clicking
  attr_accessor :mouse_tear_size
  attr_accessor :mouse_influence_scalar

  # amount to accelerate everything downward
  attr_accessor :gravity

  # Dimensions for our curtain. These are number of PointMasss for each direction, not actual widths and heights
  # the true width and height can be calculated by multiplying resting_distances by the curtain dimensions
  attr_accessor :curtain_height
  attr_accessor :curtain_width
  attr_accessor :y_start # where will the curtain start on the y axis?
  attr_accessor :resting_distances
  attr_accessor :stiffnesses
  attr_accessor :curtain_tear_sensitivity # distance the PointMasss have to go before ripping

  # Physics, see physics.pde
  attr_accessor :physics

  attr_accessor :width, :height

  def initialize
    @pointmasses = []

    @mouse_influence_size = 20
    @mouse_tear_size = 8
    @mouse_influence_scalar = 5
    @gravity = -980

    @curtain_height = 40
    @curtain_width = 60
    @y_start = 720 - 25
    @resting_distances = 6
    @stiffnesses = 1
    @curtain_tear_sensitivity = 50
  end

  def setup
    # TODO: handle size (width/height)
    size(1280, 720)

    @physics = Physics.new

    # we square the mouse_influence_size and mouse_tear_size so we don't have to use squareRoot when comparing distances with this.
    @mouse_influence_size *= mouse_influence_size
    @mouse_tear_size *= mouse_tear_size

    # We use an ArrayList instead of an array so we can add or remove PointMasss at will.
    # not that it isn't possible using an array, it's just more convenient this way
    @pointmasses = []

    # create the curtain
    create_curtain

    # create the ragdolls
    create_bodies
  end

  def size(w, h)
    @width = w
    @height = h
  end

  def draw
    $args.outputs.background_color = [255, 255, 255]

    physics.update

    update_graphics

    # Print frame rate every now and then
    #  if (frameCount % 60 == 0)
    #    println("Frame rate is " + frameRate);
    $args.outputs.labels << { x: 20, y: $args.grid.top - 20, text: "FPS: #{$gtk.current_framerate.to_s}" }
  end

  # Draw everything
  def update_graphics
    pointmasses.each(&:draw)
    physics.circles.each(&:draw)
  end

  def add_point_mass(p)
    pointmasses.push(p)
  end

  def remove_point_mass(p)
    pointmasses.delete(p)
  end

  def create_curtain
    # mid_width: amount to translate the curtain along x-axis for it to be centered
    # (curtain_width * resting_distances) = curtain's pixel width
    mid_width = (width / 2 - (curtain_width * resting_distances) / 2)
    # Since this our fabric is basically a grid of points, we have two loops
    curtain_height.times do |y| # due to the way PointMasss are attached, we need the y loop on the outside
      curtain_width.times do |x|
        pointmass = PointMass.new(mid_width + x * resting_distances, y_start - y * resting_distances);

        # attach to
        # x - 1  and
        # y - 1
        #  *<---*<---*<-..
        #  ^    ^    ^
        #  |    |    |
        #  *<---*<---*<-..
        #
        # PointMass attach_to parameters: PointMass PointMass, float restingDistance, float stiffness
        # try disabling the next 2 lines (the if statement and attach_to part) to create a hairy effect
        pointmass.attach_to(pointmasses[pointmasses.size - 1], resting_distances, stiffnesses, curtain_tear_sensitivity) if x != 0

        if y == 0
          # we pin the very top PointMasss to where they are
          pointmass.pin_to(pointmass.x, pointmass.y)
        else
          # the index for the PointMasss are one dimensions,
          # so we convert x,y coordinates to 1 dimension using the formula y*width+x
          pointmass.attach_to(pointmasses[(y - 1) * curtain_width + x], resting_distances, stiffnesses, curtain_tear_sensitivity)
        end

        # add to PointMass array
        pointmasses.push(pointmass)
      end
    end
  end

  def create_bodies
    25.times do
      Body.new(rand(width), rand(height), 40)
    end
  end

  # Controls. The r key resets the curtain, g toggles gravity
  def handle_inputs
    if $args.inputs.keyboard.key_down.r
      @pointmasses = []
      physics.circles = []
      create_curtain
      create_bodies
    end

    toggle_gravity if $args.inputs.keyboard.key_down.g
  end

  def toggle_gravity
    @gravity = gravity == 0 ? -980 : 0
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
end
