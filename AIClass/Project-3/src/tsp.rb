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
  # data - output from 'parse' method
  #
  # Returns a Hash in the following form:
  #   {
  #     solution:     [Array],
  #     time:         [Integer] solve-time in milliseconds,
  #     transitions:  [Integer]
  #   }
  def self.solve(data)
    @data      = data
    nodes      = data.keys
    start_node = data.keys.sample
    edges      = []

    nodes.delete(start_node)

    # Find the next closest node
    closest_node = closest_node_to(start_node, nodes)
    nodes.delete(closest_node)

    # link the two nodes by creating a cyclic-link
    edges << { nodes: [start_node, closest_node] }
    edges << { nodes: [closest_node, start_node] }

    # keep adding nodes until they have all been added
    until nodes.empty?
      closest = { node: nil, dist: 1.0/0, edge: nil }
      edges.each do |edge|
        nodes.each do |node|
          dist = distance_to_edge(edge, node)
          if dist < closest[:dist]
            closest = { node: node, dist: dist, edge: edge }
          end
        end
      end
      edges << extend_edge(closest[:edge], closest[:node])
      nodes.delete(closest[:node])
    end

    edges
  end


  # Replace a single edge with two edges such that the new node sits inbetween 
  # the two nodes that were previously connected by a single edge
  #
  # This method will modify the edge taht is passed into the function
  # and will return a new edge that should be added to the list of
  # edges.
  def self.extend_edge(edge, node)
    old_node = edge[:nodes].pop
    edge[:nodes] << node
    { nodes: [old_node, node] }
  end
  

  # get the distance between an edge and a node
  def self.distance_to_edge(edge, node)
    Math.sqrt(distance_to_edge_squared(edge,node))
  end

  # Get the squared distance from and edge to a node using
  # the closest point on the edge (line-segment)
  # 
  # Note: I had to Google some geometry tricks to come up with
  #       this one.
  def self.distance_to_edge_squared(edge, node)
    p1 = @data[edge[:nodes].first]
    p2 = @data[edge[:nodes].last]
    n  = @data[node]

    length_squared = distance_squared(p1, p2)
    return distance_squared(p1, n) if length_squared == 0.0

    t = ((n[:x] - p1[:x]) * (p2[:x] - p1[:x]) + (n[:y] - p1[:y]) * (p2[:y] - p1[:y]))
    t /= length_squared

    return distance_squared(n, p1) if t < 0
    return distance_squared(n, p2) if t > 1
    return distance_squared(n, {
      x: p1[:x] + t * (p2[:x] - p1[:x]),
      y: p1[:y] + t * (p2[:y] - p1[:y])
    })
  end

  # Get the distance squared between two points
  def self.distance_squared(p1, p2)
    (p1[:x] - p2[:x])**2 + (p1[:y] - p2[:y])**2
  end


  # get the closest node to the node provided
  def self.closest_node_to(node, nodes)
    closest_node = {node: nil, dist: 1.0/0}  #infinity
    nodes.each do |n|
      dist = distance_from_node(@data[n], @data[node])
      if dist < closest_node[:dist]
        closest_node = {node: n, dist: dist}
      end
    end
    closest_node[:node]
  end
  

  # Returns the distance from node n1 to node n2
  def self.distance_from_node(n1, n2)
    Math.sqrt( (n2[:x] - n1[:x])**2 + (n2[:y] - n1[:y])**2 )
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



  # Calculate the total cost of all the edges
  def self.calculate_cost(edges)
    cost = edges.inject(0) do |sum, edge|
      sum += distance_from_node(
        @data[edge[:nodes].first],
        @data[edge[:nodes].last]
      )
    end
  end

end
