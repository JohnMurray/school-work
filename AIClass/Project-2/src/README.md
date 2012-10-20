# README

## Running
To run the program, you will need to have installed Ruby. The program was
tested against Ruby 1.9.3-p194 (MRI) and JRuby-1.7.0-preview2. You can run
from the command line via:

  ruby main.rb <tsp_file>

Example:

  ruby main.rb 11PointDFSBFS.tsp


## Output
The program will run both the DFS and the BFS algorithms. It will print out a
Hash representation of the results of running TSP.sove(...). This result will
include:

+ solution:    The solution path (eg. [1, 2, 3, 4])
+ time:        Time in milliseconds it took to run/find a solution
+ transitions: number of transitions made

Some example output:

  bfs
  {:solution=>[1, 3, 5, 8, 11], :time=>0.028036000000000002, :transitions=>10}
  dfs
  {:solution=>[1, 2, 3, 4, 5, 7, 9, 11], :time=>0.031434, :transitions=>7}
