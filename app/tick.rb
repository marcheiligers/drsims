def boot(_args)
  $sim = Simulator.new
  $sim.setup
end

def tick(_args)
  $sim.handle_inputs
  $sim.tick
  $args.outputs.labels << { x: 20, y: 700, text: "FPS: #{$gtk.current_framerate.round(2)}" }
end
