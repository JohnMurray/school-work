
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
        points[match[:point].to_sym] = {
          x: match[:coord1].to_f,
          y: match[:coord2].to_f
        }
      end
    end

    points
  end


  # Compute the total distances for a single path
  # 
  # The path is given as a single-level (flat) array that is filled with
  # keys to the points array in the order that they should be traveled in.
  # 
  #   [:p1, :p2, :p3, etc.]
  # 
  # The points hash will look like:
  # 
  #   {
  #     p1: { x: <float>, y: <float> },
  #     p2: { x: <float>, y: <float> },
  #     ...
  #   }
  def self.compute_path_total(path, points)
    sum = 0
    path.each_with_index do |p, i|
      sum += compute_distance( points[p], points[path[i+1]] || points[path[0]] )
    end
    sum
  end


  # Computer the distance between two points. Each point is
  # expected to be in the following format:
  #
  #   { x: <float>, y: <float> }
  def self.compute_distance(p1, p2)
    Math.sqrt( (p2[:x] - p1[:x])**2 + (p2[:y] - p1[:y])**2 ).abs
  end
end
