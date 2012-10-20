# require project files
require './tsp'


# The main runner for the program. This is really just the entry point
# that glues everything together. No real magic is happening here.
#
# Although, I will keep track of how many items we are going to process
# and show some sort of progress meter (since this will be a brute-force
# approach)
def main
  tsp_file = ARGV[0] if ARGV
  raise 'No .tsp file was provided. Run "ruby main.rb <file>' unless tsp_file

  tsp_data = TSP.parse( File.open(tsp_file).read )
  nodes    = tsp_data.keys

  TSP.build_graph!( tsp_data )

  tsp_data2 = Marshal.load( Marshal.dump( tsp_data ) ) #deep copy

  # print results
  puts :bfs, TSP.solve(tsp_data,  method: :bfs)
  puts :dfs, TSP.solve(tsp_data2, method: :dfs)
end





main if $0 == __FILE__
