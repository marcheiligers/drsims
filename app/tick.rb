def boot(_args)
  $sim = Simulator.new
  $sim.setup
end

def tick(_args)
  $sim.handle_inputs
  $sim.draw
end
