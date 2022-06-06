RED = { r: 255, g: 0, b: 0 }.freeze
BLACK = { r: 0, g: 0, b: 0 }.freeze

def len(x, y)
  Math.sqrt(x**2 + y**2)
end

def calc_point_on_circle(r, angle)
  {
    x: (90 + angle).sin * r,
    y: (90 + angle).cos * r
  }
end

def calc_point_angle(x, y)
  Math.atan2(y, x).to_degrees
end

def point(x, y)
  $args.outputs.solids << { x: x, y: y, w: 1, h: 1, **BLACK }
end

def line(x1, y1, x2, y2)
  $args.outputs.lines << { x: x1, y: y1, x2: x2, y2: y2 }
end

def ellipse(x, y, w, h)
  $args.outputs.sprites << { x: x, y: y, w: w, h: h, path: 'sprites/circle/white.png' }
end

def random(low, high)
  rand(high - low) + low
end

def millis
  $args.state.tick_count * 16
end
