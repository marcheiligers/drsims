# https://gamedevelopment.tutsplus.com/tutorials/simulate-tearable-cloth-and-ragdolls-with-simple-verlet-integration--gamedev-519
HEIGHT = 720
WIDTH = 1280

MOUSE_INFLUENCE_SIZE = 20 * 20 # squared
MOUSE_TEAR_SIZE = 8 * 8 # squared

BODIES = 25

CURTAIN_HEIGHT = 60
CURTAIN_WIDTH = 40
Y_START = 720 - 25
RESTING_DISTANCES = 8
STIFFNESSES = 1
CURTAIN_TEAR_SENSITIVITY = 50

TIME_STEP_AMT_MIN = 1
CONSTRAINT_ACCURACY = 3
FIXED_DELTA_TIME = 16
FIXED_DELTA_TIME_SECONDS = FIXED_DELTA_TIME / 1000.0
FIXED_DELTA_TIME_SECONDS_SQ = FIXED_DELTA_TIME_SECONDS * FIXED_DELTA_TIME_SECONDS
MOUSE_INFLUENCE_SCALAR = 1.0 / TIME_STEP_AMT_MIN

class Simulator
  # Where we'll store all of the points
  attr_reader :pointmasses, :circles

  # amount to accelerate everything downward
  attr_reader :gravity

  # previous mouse position
  attr_reader :pmouse_x, :pmouse_y

  def initialize
    @gravity = -980

    @pmouse_x = 0
    @pmouse_y = 0
  end

  def setup
    @pointmasses = []
    @circles = []

    create_curtain
    create_bodies
    add_outputs
  end

  def tick
    $args.outputs.background_color = [255, 255, 255]

    ca = 0
    while ca < CONSTRAINT_ACCURACY
      l = @pointmasses.size
      i = 0
      while i < l
        @pointmasses[i].solve_constraints
        i += 1
      end

      l = @circles.size
      i = 0
      while i < l
        @circles[i].solve_constraints
        i += 1
      end

      ca += 1
    end

    # update each PointMass's position
    mouse_x = $args.inputs.mouse.x
    mouse_y = $args.inputs.mouse.y
    button_left = $args.inputs.mouse.button_left
    button_right = $args.inputs.mouse.button_right
    l = @pointmasses.size
    i = 0
    while i < l
      @pointmasses[i].update(mouse_x, mouse_y, @pmouse_x, @pmouse_y, button_left, button_right, @gravity)
      i += 1
    end

    @pmouse_x = mouse_x
    @pmouse_y = mouse_y
  end

  def add_circle(c)
    @circles.push(c)
  end

  def remove_circle(c)
    @circles.delete(c)
  end

  def add_outputs
    $args.outputs.static_lines.clear
    $args.outputs.static_lines << @pointmasses
    $args.outputs.static_lines << @circles
  end

  def add_point_mass(p)
    @pointmasses.push(p)
  end

  def remove_point_mass(p)
    @pointmasses.delete(p)
  end

  def create_curtain
    # mid_width: amount to translate the curtain along x-axis for it to be centered
    mid_width = (WIDTH / 2 - (CURTAIN_WIDTH * RESTING_DISTANCES) / 2)
    # Since this our fabric is basically a grid of points, we have two loops
    CURTAIN_HEIGHT.times do |y| # due to the way PointMasss are attached, we need the y loop on the outside
      CURTAIN_WIDTH.times do |x|
        pointmass = PointMass.new(mid_width + x * RESTING_DISTANCES, Y_START - y * RESTING_DISTANCES)

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
        pointmass.attach_to(@pointmasses[@pointmasses.size - 1], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY) if x != 0

        if y == 0
          # we pin the very top PointMasss to where they are
          pointmass.pin_to(pointmass.x, pointmass.y)
        else
          # the index for the PointMasss are one dimensions,
          # so we convert x,y coordinates to 1 dimension using the formula y*width+x
          pointmass.attach_to(@pointmasses[(y - 1) * CURTAIN_WIDTH + x], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY)
        end

        # add to PointMass array
        @pointmasses.push(pointmass)
      end
    end
  end

  def create_tri_curtain
    mid_width = (WIDTH / 2 - (CURTAIN_WIDTH * RESTING_DISTANCES) / 2)
    rows = []
    row = nil
    CURTAIN_HEIGHT.times do |y|
      prev_row = row
      row = []
      (CURTAIN_WIDTH + (y.odd? ? 1 : 0)).times do |x|
        pointmass = PointMass.new(mid_width + x * RESTING_DISTANCES + (y.odd? ? 0 : RESTING_DISTANCES / 2), Y_START - y * RESTING_DISTANCES)

        # attach left
        pointmass.attach_to(row[x - 1], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY) if x != 0

        if y == 0
          pointmass.pin_to(pointmass.x, pointmass.y)
        elsif y.odd?
          pointmass.attach_to(prev_row[x], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY) if x < CURTAIN_WIDTH
          pointmass.attach_to(prev_row[x - 1], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY) if x > 0
        else
          pointmass.attach_to(prev_row[x], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY)
          pointmass.attach_to(prev_row[x + 1], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY)
        end

        row.push(pointmass)
      end
      rows << row
    end
    @pointmasses = rows.flatten
  end

  def create_hex_curtain
    mid_width = (WIDTH / 2 - (CURTAIN_WIDTH * RESTING_DISTANCES) / 2)
    rows = []
    row = nil
    CURTAIN_HEIGHT.times do |y|
      prev_row = row
      row = []
      CURTAIN_WIDTH.times do |x|
        if x == 0
          x_offset = mid_width + (y.odd? ? (RESTING_DISTANCES / 2) : 0)
          pointmass = PointMass.new(x_offset, Y_START - y * RESTING_DISTANCES)
        elsif (y.even? && x.odd?) || (y.odd? && x.even? && x > 0)
          x_offset = mid_width + (RESTING_DISTANCES / 2) + (x + 1) * RESTING_DISTANCES
          pointmass = PointMass.new(x_offset, Y_START - y * RESTING_DISTANCES)

          # attach left
          pointmass.attach_to(row[x - 1], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY)
        else
          x_offset = mid_width + (x + 1) * RESTING_DISTANCES
          pointmass = PointMass.new(x_offset, Y_START - y * RESTING_DISTANCES)
        end

        if y == 0
          pointmass.pin_to(pointmass.x, pointmass.y)
        else
          pointmass.attach_to(prev_row[x], RESTING_DISTANCES, STIFFNESSES, CURTAIN_TEAR_SENSITIVITY)
        end

        row.push(pointmass)
      end
      rows << row
    end
    @pointmasses = rows.flatten
  end

  def create_bodies
    BODIES.times do
      Body.new(rand(WIDTH), rand(HEIGHT), 40)
    end
  end

  # Controls. The r key resets the curtain, g toggles gravity
  def handle_inputs
    setup if $args.inputs.keyboard.key_down.r
    toggle_gravity if $args.inputs.keyboard.key_down.g
  end

  def toggle_gravity
    @gravity = gravity == 0 ? -980 : 0
  end
end
