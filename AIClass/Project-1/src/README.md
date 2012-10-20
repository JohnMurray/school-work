# README

## Running
To run the program, you will need to have installed Ruby. The program was
tested against Ruby 1.9.3-p194 (MRI) and JRuby-1.7.0-preview2. You can run
from the command line via:

  ruby main.rb <tsp_file>

Example:

  ruby main.rb Random6.tsp


## Output
The program will let you know how many permutations it is working through
and give you an indication of progress by letting you know each time another
2 million permutations have been processed. When it is complete, it will output
the optimal path and the cost of the path. 

Note: It is assumed that the path will loop back to the beginning and this is
      not reflected in the path. 
      Ex: path:   1 2 3 4 1
          output: 1 2 3 4
