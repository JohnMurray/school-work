require './tsp'
require './solver'

# Getting the GUI application up and running with our Shoes on!
#
# We're going to start an instance of the solver and draw the initial
# GUI window (Yeah, I'm mixing up responsibilities a little bit but
# this is my first introduction to Shoes, so I'm not exactly up on the
# 'Best Pracitices' just quite yet).
Shoes.app :title => 'Project 3 - John Murray', :width => 700, :height => 600 do
  solver = ::Solver.new(self)
  solver.draw
end

