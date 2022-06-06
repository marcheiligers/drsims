# Physics
# Timesteps are managed here
class Physics
  # list of circle constraints
  attr_accessor :circles

  attr_accessor :previous_time
  attr_accessor :current_time

  attr_accessor :fixed_delta_time
  attr_accessor :fixed_delta_time_seconds

  attr_accessor :left_over_delta_time

  attr_accessor :constraint_accuracy

  def initialize
    @circles = []

    @fixed_delta_time = 16
    @fixed_delta_time_seconds = @fixed_delta_time / 1000.0
    @left_over_delta_time = 0
    @constraint_accuracy = 3
    @previous_time = millis
  end

  # Update physics
  def update
    # calculate elapsed time
    @current_time = millis
    delta_time_ms = current_time - previous_time

    @previous_time = current_time # reset previous time

    # break up the elapsed time into manageable chunks
    time_step_amt = (delta_time_ms + left_over_delta_time) / fixed_delta_time

    # limit the time_step_amt to prevent potential freezing
    time_step_amt = [time_step_amt, 5].min.to_i

    # store however much time is leftover for the next frame
    @left_over_delta_time = delta_time_ms - (time_step_amt * fixed_delta_time)

    # How much to push PointMasses when the user is interacting
    # TODO: global???
    $sim.mouse_influence_scalar = 1.0 / time_step_amt

    # update physics
    time_step_amt.times do
      # solve the constraints multiple times
      # the more it's solved, the more accurate.
      constraint_accuracy.times do
        # TODO: global pointmasses
        $sim.pointmasses.each(&:solve_constraints)
        circles.each(&:solve_constraints)
      end

      # update each PointMass's position
      $sim.pointmasses.each do |pointmass|
        pointmass.update_interactions
        pointmass.update_physics(fixed_delta_time_seconds)
      end
    end
  end

  def add_circle(c)
    circles.push(c)
  end

  def remove_circle(c)
    circles.delete(c)
  end
end
