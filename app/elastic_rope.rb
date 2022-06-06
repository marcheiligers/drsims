# https://web.archive.org/web/20160418004153/http://freespace.virgin.net/hugo.elias/models/m_string.htm
class ElasticRope
  NORMAL_LENGTH = 1
  GRAVITY = -10
  ADJUST = 0.3

  def initialize
    # Create 4 arrays of numbers:
    # String1_X (0 to 31)
    # String1_Y (0 to 31)
    # String2_X (0 to 31)
    # String2_Y (0 to 31)
    # Velocity_X (i)
    # Velocity_Y (i)
    # Initialise all the points in String_X() and String_Y():

    # Loop i from 0 to 31
    #     String1_X (i) = 0
    #     String1_Y (i) = i
    # end of loop
    @string1_x = Array.new(32) { |i| 300 + 10 * i }
    @string1_y = Array.new(32) { |i| i < 16 ? 720 - (i * NORMAL_LENGTH) : (720 - 16 * NORMAL_LENGTH) + (i - 16) * NORMAL_LENGTH }
puts @string1_y
    @string2_x = Array.new(32)
    @string2_y = Array.new(32)
    # @velocity_x = Array.new(32)
    # @velocity_y = Array.new(32)
  end

  # Loop Forever
  def tick(args)
    # Loop i from 0 to 31
    32.times.map do |i|
      if i > 0 && i < 31
        # X_vector1 = String1_X(i- 1) - String1_X(i)
        # Y_vector1 = String1_Y(i - 1) - String1_Y(i)
        # Magnitude1 = LengthOf (X_Vector1, Y_Vector1)
        # Extension1 = Magnitude1 - Normal_Length
        x_vector1 = @string1_x[i - 1] - @string1_x[i]
        y_vector1 = @string1_y[i - 1] - @string1_y[i]
        magnitude1 = len(x_vector1, y_vector1)
        extension1 = magnitude1 - NORMAL_LENGTH

        # X_vector2 = String1_X(i + 1) - String1_X(i)
        # Y_vector2 = String1_Y(i + 1) - String1_Y(i)
        # Magnitude2 = LengthOf(X_Vector2, Y_Vector2)
        # Extension2 = Magnitude2 - Normal_Length
        x_vector2 = @string1_x[i + 1] - @string1_x[i]
        y_vector2 = @string1_y[i + 1] - @string1_y[i]
        magnitude2 = len(x_vector2, y_vector2)
        extension2 = magnitude2 - NORMAL_LENGTH

        # xv = (X_Vector1 / Magnitude1 * Extension1) + (X_Vector2 / Magnitude2 * Extension2)
        # yv = (Y_Vector1 / Magnitude1 * Extension1) + (Y_Vector2 / Magnitude2 * Extension2) + Gravity
        xv = (x_vector1 / magnitude1 * extension1) + (x_vector2 / magnitude2 * extension2)
        yv = (y_vector1 / magnitude1 * extension1) + (y_vector2 / magnitude2 * extension2) + GRAVITY

        # String2_X(i) = String1_X(i) + (xv * .01)
        # String2_Y(i) = String1_Y(i) + (yv * .01)
        # (Note you can use what ever value you like instead of .01)
        @string2_x[i] = @string1_x[i] + (xv * ADJUST)
        @string2_y[i] = @string1_y[i] + (yv * ADJUST)

        # Velocity_X(i) = Velocity_X(i) * Damping + (xv * .001)
        # Velocity_Y(i) = Velocity_Y(i) * Damping + (yv * .001)
        # String2_X(i)  = String1_X(i) + Velocity_X(i)
        # String2_Y(i)  = String1_Y(i) + Velocity_Y(i)
      else
        @string2_x[i] = @string1_x[i]
        @string2_y[i] = @string1_y[i]
      end
    end
    # end of loop

    # Copy all of String2_X to String1_X
    # Copy all of String2_Y to String1_Y
    @string1_x = @string2_x.dup
    @string1_y = @string2_y.dup

    # Draw lines between all adjacent points
    31.times.map do |i|
      args.outputs.lines << { x: @string1_x[i], y: @string1_y[i], x2: @string1_x[i + 1], y2: @string1_y[i + 1] }
      args.outputs.solids << { x: @string1_x[i] - 2, y: @string1_y[i] - 2, w: 5, h: 5, **RED }
    end
    args.outputs.solids << { x: @string1_x[31] - 2, y: @string1_y[31] - 2, w: 5, h: 5, **RED }
  end
  # end of LoopForever
end
