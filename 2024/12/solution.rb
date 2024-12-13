GARDEN = File.readlines('input.txt', chomp: true).map(&:chars)

plots = Hash.new { |hash, key| hash[key] = [] }

def add_to_or_create_plot(flower, coordinates, plots)
  x, y = coordinates

  if plots.key?(flower)
    plots_to_add_to = plots[flower].filter do |plotz|
      plotz.any? do |fx, fy|
        dx = (x - fx).abs
        dy = (y - fy).abs
  
        dx + dy == 1
      end
    end
  
    if plots_to_add_to.empty?
      plots[flower] << [coordinates]
    elsif plots_to_add_to.count > 1
      indexes = plots_to_add_to.map { plots[flower].index(_1) }
      plots[flower][indexes.first] = plots_to_add_to.flatten(1) << coordinates
      indexes[1..].each{ plots[flower].delete_at(_1) }
    else
      index = plots[flower].index(plots_to_add_to.first)
      plots[flower][index] << coordinates
    end
  else
    plots[flower] << [coordinates]
  end
end

GARDEN.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    add_to_or_create_plot(cell, [x, y], plots)
  end
end

def plot_area(plot)
  plot.count
end

def plot_perimeter(plot, flower)
  plot.map do |cell|
    x, y = cell
    edges = 0
    edges += 1 if x.zero? || GARDEN[y][x - 1] != flower
    edges += 1 if y.zero? || GARDEN[y - 1][x] != flower
    edges += 1 if x == GARDEN.first.size - 1 || GARDEN[y][x + 1] != flower
    edges += 1 if y == GARDEN.size - 1 || GARDEN[y + 1][x] != flower
    edges
  end.sum
end

costs =  plots.map do |flower, plotz|
  plotz.map do |plot| 
    plot_area(plot) * plot_perimeter(plot, flower)
  end.sum
end.sum

