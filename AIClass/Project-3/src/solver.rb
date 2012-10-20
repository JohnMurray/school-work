# The solver class is responsible for quite a few things. To put that in list
# from is:
#  + Draw the initial GUI elements
#  + Read file-input and call TSP for parsing
#  + Display status messages (so the user knows what's going on)
#  + Call TSP for solve
#  + Draw the results (and manage all drawing elements)
#  + Call TSP to get the total calcualte cost
class Solver

  # Initialize the application with the instance of Shoes (the
  # GUI object.
  def initialize(app)
    @app = app
  end

  # Draw the initial fields required to get this thing a-going.
  # basically just the file-select and a text-box.
  def draw
    #@app.flow do
      @app.button 'Open TSP File', :width => '100%' do
        file = @app.ask_open_file
        if file
          do_computation(file)
        else
          @app.alert('No file selected')
        end
      end
    #end
    @note = @app.para('Open a TSP file to get started.')
  end

  def do_computation(file)
    (@drawn_objects ||= []).each {|o| o.remove }
    file_contents = File.open(file).read

    @note.replace('Parsing...')
    @tsp_data = ::TSP.parse(file_contents)

    @note.replace('Solving...')
    edges = nil
    time = TSP.t do
      edges = ::TSP.solve(@tsp_data)
    end
    cost  = ::TSP.calculate_cost(edges)
    
    @note.replace("Solved.  Cost: #{cost}, Time: #{time}")
    draw_edges(edges)
  end

  # draw the edges onto the Window given the edges (detailing which
  # nodes are connected) and the original tsp_data (which contains
  # the coordinate values and what not).
  #
  # edges    - In form of:
  #            { nodes: [n1, n2] }
  #            where each element in 'nodes' is a key to tsp_data
  # tsp_data - data directly from TSP.parse(...)
  def draw_edges(edges)

    edges.each do |edge|
      n1, n2 = edge[:nodes]
      p1 = draw_node(@tsp_data[n1])
      p2 = draw_node(@tsp_data[n2])
      @drawn_objects << @app.line(p1[:x], p1[:y], p2[:x], p2[:y])
    end
  end


  # Draw a node on the Window. (First need to scale it down)
  def draw_node(n)
    @padding ||= {
      top:      50,
      left:     20
    }
    @width  ||= 660
    @height ||= 530

    coords = {
      x: (n[:x] / max_x) * @width + @padding[:left],
      y: (n[:y] / max_y) * @height + @padding[:top]
    }
    
    @drawn_objects << @app.oval( left: coords[:x], top: coords[:y], radius: 4)
    coords
  end

  # Return the max X value for all nodes in the set
  def max_x
    @max_x ||= @tsp_data.map{|_,v| v[:x]}.max
  end

  # Return the max Y value for all nodes in the set
  def max_y
    @max_y ||= @tsp_data.map{|_,v| v[:y]}.max
  end
end
