BRIDGE = 11.times.map do |lx|
  x = lx * 50
  { x: x + 100, y: 119.0573 + 234.7708 * Math.cosh(0.0043 * (x - 250)) }
end.freeze

LEN = len(BRIDGE[1][:x] - BRIDGE[0][:x], BRIDGE[1][:y] - BRIDGE[0][:y])
RED = { r: 255, g: 0, b: 0 }.freeze
BLUE = { r: 0, g: 0, b: 255 }.freeze

$weight = 1

def rope_math_rq(args)
  args.outputs.lines << { x: 600, y: 600, x2: 700, y2: 600 }
  pp = calc_point_on_circle(100, 5)
  args.outputs.lines << { x: 600, y: 600, x2: 600 + pp[:x], y2: 600 + pp[:y] }
  args.outputs.labels << { x: 20, y: 30, text: "a = #{calc_point_angle(100, 0)} LEN = #{LEN}" }

  p0 = BRIDGE.first
  l = nil
  bridge = BRIDGE.map_with_index do |pc, i|
    pa = if i == $weight
           a = calc_point_angle(pc[:x], pc[:y])
           pn = calc_point_on_circle(LEN, a - 1)
           # puts "p0 = #{p0}, pn = #{pn}, a = #{a}"
           { x: p0[:x] + pn[:x], y: p0[:y] + pn[:y] }
         elsif !l.nil?
           { x: pc[:x], y: pc[:y] }
         else
           { x: pc[:x], y: pc[:y] }
         end
    p0 = pa
  end

  bridge.each_cons(2).with_index do |(p0, p1), i|
    args.outputs.lines << { x: p0[:x], y: p0[:y], x2: p1[:x], y2: p1[:y] }
    args.outputs.solids << { x: p0[:x] - 2, y: p0[:y] - 2, w: 5, h: 5, **($weight == i ? RED : BLUE)}
  end
end
