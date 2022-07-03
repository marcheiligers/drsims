fun init = Verlet_init(val : LibC::Char) : Void
  # We need to initialize the GC
  GC.init

  # We need to invoke Crystal's "main" function, the one that initializes
  # all constants and runs the top-level code (none in this case, but without
  # constants like STDOUT and others the last line will crash).
  # We pass 0 and null to argc and argv.
  LibCrystalMain.__crystal_main(0, Pointer(Pointer(UInt8)).null)

  puts "Verlet_init"
end

@[Extern]
struct Verlet_SolveResult
  property p1x : Float64 = 0
  property p1y : Float64 = 0
  property p2x : Float64 = 0
  property p2y : Float64 = 0
  property rm : LibC::Char = 0

  def initialize(@p1x : Float64, @p1y : Float64, @p2x : Float64, @p2y : Float64, rm : LibC::Char)
  end
end

fun solve = Verlet_solve(p1x : Float64, p1y : Float64, p2x : Float64, p2y : Float64,
                         tear_sensitivity : Float64, resting_distance : Float64,
                         scalar_p1 : Float64, scalar_p2 : Float64) : Verlet_SolveResult
  # calculate the distance between the two PointMasss
  diffx = p1x - p2x
  diffy = p1y - p2y
  d = Math.sqrt(diffx * diffx + diffy * diffy)
  puts "#{d} > #{tear_sensitivity}"
  # if the distance is more than curtainTearSensitivity, the cloth tears
  remove_link = LibC::Char.new(d > tear_sensitivity ? 1 : 0)

  # find the difference, or the ratio of how far along the restingDistance the actual distance is.
  difference = (resting_distance - d) / d

  # Push/pull based on mass
  # heavier objects will be pushed/pulled less than attached light objects
  p1x += diffx * scalar_p1 * difference
  p1y += diffy * scalar_p1 * difference

  p2x -= diffx * scalar_p2 * difference
  p2y -= diffy * scalar_p2 * difference

  Verlet_SolveResult.new(p1x, p1y, p2x, p2y, remove_link)
end
