require 'priority_queue'

class Route
  attr_accessor :src , :dest, :dist
  def initialize(src,dest,dist)
    self.src = src
    self.dest = dest
    self.dist = dist
  end
end

class Map
  attr_accessor :routes
  def initialize
    self.routes = make_routes
  end

  def shortest_path(src, dest)
    maxint = Float::INFINITY

    distances = {}
    previous = {}
    nodes = PriorityQueue.new
    
    routes.each do | vertex, value |
        if vertex == src
            distances[vertex] = 0
            nodes[vertex] = 0
        else
            distances[vertex] = maxint
            nodes[vertex] = maxint
        end
        previous[vertex] = nil
    end

    while nodes
        smallest = nodes.delete_min_return_key
        if smallest == dest
            path = []
            while previous[smallest]
                path.push(smallest)
                smallest = previous[smallest]
            end
            return path.reverse.unshift(src).join(" -> ")
        end
        
        if smallest == nil or distances[smallest] == maxint
          break            
        end
        
        routes[smallest].each do | neighbor, value |
            alt = distances[smallest] + routes[smallest][neighbor]
            if alt < distances[neighbor]
                distances[neighbor] = alt
                previous[neighbor] = smallest
                nodes[neighbor] = alt
            end
        end
    end
  end

  private
  def make_routes
    all_routes = [Route.new("Bengaluru", "Mumbai", 12),
              Route.new("Bengaluru", "Chennai", 4),
              Route.new("Bengaluru", "Kochi", 10),
              Route.new("Delhi", "Chennai", 48),
              Route.new("Delhi","Bengaluru", 24),
              Route.new("Mumbai", "Delhi", 11),
              Route.new("Mumbai", "Chennai", 28),
              Route.new("Kochi", "Chennai", 7),
              Route.new("Jaipur", "Nagpur", 12),
              Route.new("Kochi", "Thrissur", 12)]
    routes = {}
    all_routes.map { |route| routes[route.src] ||= {}; routes[route.src].merge!({"#{route.dest}" => route.dist});
    routes[route.dest] ||= {}; routes[route.dest].merge!({"#{route.src}" => route.dist})}
    routes
  end
end

puts Map.new.shortest_path("Mumbai","Thrissur")
puts Map.new.shortest_path("Mumbai","Kochi")
puts Map.new.shortest_path("Kochi","Thrissur")
