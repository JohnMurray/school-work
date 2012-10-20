
# Contains all of the utility functions for processing and solving the
# travelling salesman problem. Currently none of the solutions require
# any type of data-structure outside of hashes and arrays, so this is
# bascially a grouping of methods at the moment.
module TSP
  TSP_REGEX = /^(?<point>\d+)\s+(?<coord1>\d+(\.\d+)?)\s+(?<coord2>\d+(\.\d+)?)/

  # Parse the *.tsp file into an Hash where the key is the point and 
  # the value is the location of the point.
  #
  # input_file  => A string (not a file-descriptor)
  # 
  # The value is in the format of:
  #   { x: c1, y: c2 }
  # Yes, I am assuming a 2-dimensional space
  def self.parse( input_file )
    points = {}

    lines = input_file.split( "\n" )
    lines.each do |line|
      match = TSP_REGEX.match( line )
      if match
        points[match[:point].to_i] = {
          x: match[:coord1].to_f,
          y: match[:coord2].to_f
        }
      end
    end

    points
  end


  # A generic method to solve the problem that keeps track
  # of transitions and execution times.
  #
  # Returns a Hash in the following form:
  #   {
  #     solution:     [Array],
  #     time:         [Integer] solve-time in milliseconds,
  #     transitions:  [Integer]
  #   }
  def self.solve(data, opts = {})
    opts[:method] ||= :bfs
    solution = nil

    reset_transitions
    time = t do
      solution = case opts[:method]
                 when :bfs; bfs(data, opts)
                 when :dfs; dfs(data, opts)
                 end
    end

    {
      solution:     solution,
      time:         time,
      transitions:  transition_count
    }
  end


  # Record the time of any block (executed immediately, so no worries
  # about closure-issues). 
  #
  # Returns the time that the block took to execute (in milliseconds)
  def self.t(&block)
    t1 = Time.now
    yield
    t2 = Time.now
    
    (t2 - t1) * 1_000
  end


  # Increment the number of transitions made.
  def self.increment_transitions
    @transitions ||= 0
    @transitions += 1
  end
  class << self
    alias :incr_trans :increment_transitions
  end

  def self.transition_count
    @transitions
  end

  # Reset the number of transitions (to 0)
  def self.reset_transitions
    @transitions = 0
  end


  # Perform a depth-first search on the graph.
  #
  # graph - graph to perform operation on
  # opts  - optional parameters that allow you to perform the DFS with
  #         any start and goal states. Also allows depth-limiting if you
  #         so desire.
  #
  # Returns an array of the node-numbers which represent the path from the
  # start state to the goal state.
  def self.dfs(graph, opts = {})
    opts[:depth]     ||= 0      # current depth
    opts[:max_depth] ||= 11     # maximum depth
    opts[:node]      ||= 1      # current node
    opts[:goal]      ||= 11     # goal node

    if graph[opts[:node]] == graph[opts[:goal]]
      return opts[:node]
    end
    
    return nil if opts[:depth] == opts[:max_depth]

    graph[opts[:node]][:points_to].each do |pt|
      incr_trans

      result = dfs(graph, {
        depth:      opts[:depth] + 1,
        max_deph:   opts[:max_depth],
        node:       pt,
        goal:       opts[:goal]
      })
      if result
        return [result].flatten.unshift(opts[:node])
      end
    end

    nil
  end


  # Perform a breadth-first search on the graph. It uses the full path
  # to store in the queue, so when the solution is reached, the item
  # in the queue that is currently being processed can simply be returned
  # as the solution. 
  #
  # graph - graph to perform search on
  # opts  - extra parameters that just look nicer within a hash (honestly)
  #
  # Returns an array of the node-numbers which represent the path from the
  # start state to the goal state.
  def self.bfs(graph, opts = {})
    opts[:start] ||= 1     # start node
    opts[:goal]  ||= 11    # goal node

    queue = []
    queue << [opts[:start]]

    graph[opts[:start]][:visited] = true

    until queue.empty?
      path = queue.shift
      node = path.last

      return path if node == opts[:goal]

      graph[node][:visited] = true
      incr_trans
      
      graph[node][:points_to].each do |pt|
        unless graph[pt][:visited]
          graph[pt][:visited] = true
          new_path = path.dup
          new_path << pt
          queue << new_path
        end
      end
    end

    nil
  end


  # Setup some references from each "node" manually so we can process
  # our hash as a graph. Note that this operation does do an in-place
  # change (thus the bang(!)).
  #
  # Returns the Hash that as originally parsed with two new fields:
  #   :points_to        => from the source node to another node
  #   :points_from      => from another node to the source node
  def self.build_graph!(tsp_data)
    tsp_data[1][:points_to]  = [2, 3, 4]
    tsp_data[2][:points_to]  = [3]
    tsp_data[3][:points_to]  = [4, 5]
    tsp_data[4][:points_to]  = [5, 6, 7]
    tsp_data[5][:points_to]  = [7, 8]
    tsp_data[6][:points_to]  = [8]
    tsp_data[7][:points_to]  = [9, 10]
    tsp_data[8][:points_to]  = [9, 10, 11]
    tsp_data[9][:points_to]  = [11]
    tsp_data[10][:points_to] = [11]
  end
end
