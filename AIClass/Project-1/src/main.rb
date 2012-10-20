# require gems
require 'pry'

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

  perm_count = nodes.count.downto(1).inject(:*)
  puts "Processing #{perm_count} paths with brute force. :-)"

  progress_count      = 0
  cheapest_path_cost  = (1.0/0) #infinity
  cheapest_path       = nil

  nodes.permutation.each_with_index do |path, index|
    path_cost     = TSP.compute_path_total( path, tsp_data )
    if path_cost < cheapest_path_cost
      cheapest_path_cost = path_cost
      cheapest_path      = path
    end

    if index % 2_000_000 == 0
      puts "#{progress_count} million paths processed"
      progress_count += 2
    end
  end

  puts "cheapest path:       #{cheapest_path.join(' ')}"
  puts "cheapest path costs: #{cheapest_path_cost}"
end





main if $0 == __FILE__
