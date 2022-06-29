# Body
# Here we construct and store a ragdoll
class Body
  #   O
  #  /|\
  # / | \
  #  / \
  # |   |
  attr_reader :head, :shoulder, :elbow_left, :elbow_right, :hand_left, :hand_right, :pelvis, :knee_left,
              :knee_right, :foot_left, :foot_right, :head_circle, :head_width, :head_length

  def initialize(x, y, body_height)
    @head_length = body_height / 7.5
    @head_width = head_length * 3 / 4

    @head = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @head.mass = 4
    @shoulder = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @shoulder.mass = 26 # shoulder to torso
    @head.attach_to(shoulder, 5 / 4 * head_length, 1, body_height * 2, true)

    @elbow_left = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @elbow_right = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @elbow_left.mass = 2 # upper arm mass
    @elbow_right.mass = 2
    @elbow_left.attach_to(shoulder, head_length * 3 / 2, 1, body_height * 2, true)
    @elbow_right.attach_to(shoulder, head_length * 3 / 2, 1, body_height * 2, true)

    @hand_left = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @hand_right = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @hand_left.mass = 2
    @hand_right.mass = 2
    @hand_left.attach_to(elbow_left, head_length * 2, 1, body_height * 2, true)
    @hand_right.attach_to(elbow_right, head_length * 2, 1, body_height * 2, true)

    @pelvis = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @pelvis.mass = 15 # pelvis to lower torso
    @pelvis.attach_to(shoulder, head_length * 3.5, 0.8, body_height * 2, true)
    # this restraint keeps the head from tilting in extremely uncomfortable positions
    @pelvis.attach_to(head, head_length * 4.75, 0.02, body_height * 2, false)

    @knee_left = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @knee_right = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @knee_left.mass = 10
    @knee_right.mass = 10
    @knee_left.attach_to(pelvis, head_length * 2, 1, body_height * 2, true)
    @knee_right.attach_to(pelvis, head_length * 2, 1, body_height * 2, true)

    @foot_left = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @foot_right = PointMass.new(x + random(-5, 5), y + random(-5, 5))
    @foot_left.mass = 5 # calf + foot
    @foot_right.mass = 5
    @foot_left.attach_to(knee_left, head_length * 2, 1, body_height * 2, true)
    @foot_right.attach_to(knee_right, head_length * 2, 1, body_height * 2, true)

    # these constraints resist flexing the legs too far up towards the body
    @foot_left.attach_to(shoulder, head_length * 7.5, 0.001, body_height * 2, false)
    @foot_right.attach_to(shoulder, head_length * 7.5, 0.001, body_height * 2, false)

    head_circle = Circle.new(head_length * 0.75)
    head_circle.attach_to_point_mass(head)

    # TODO: all this is global
    $sim.add_circle(head_circle)
    $sim.add_point_mass(head)
    $sim.add_point_mass(shoulder)
    $sim.add_point_mass(pelvis)
    $sim.add_point_mass(elbow_left)
    $sim.add_point_mass(elbow_right)
    $sim.add_point_mass(hand_left)
    $sim.add_point_mass(hand_right)
    $sim.add_point_mass(knee_left)
    $sim.add_point_mass(knee_right)
    $sim.add_point_mass(foot_left)
    $sim.add_point_mass(foot_right)
  end

  # def remove_from_world
  #   $sim.physics.remove_circle(head_circle)
  #   $sim.remove_point_mass(head)
  #   $sim.remove_point_mass(shoulder)
  #   $sim.remove_point_mass(pelvis)
  #   $sim.remove_point_mass(elbow_left)
  #   $sim.remove_point_mass(elbow_right)
  #   $sim.remove_point_mass(hand_left)
  #   $sim.remove_point_mass(hand_right)
  #   $sim.remove_point_mass(knee_left)
  #   $sim.remove_point_mass(knee_right)
  #   $sim.remove_point_mass(foot_left)
  #   $sim.remove_point_mass(foot_right)
  # end
end
