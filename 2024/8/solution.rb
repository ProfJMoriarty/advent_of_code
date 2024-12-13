antennae = Hash.new { |hash, key| hash[key] = [] }
lines = File.readlines('input.txt', chomp: true)
MAX_X = lines.first.chars.count.freeze
MAX_Y = lines.count.freeze
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    next if char == '.'
    antennae[char] << [x, y]
  end
end

class Node
  attr_reader :x
  attr_reader :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def out_of_bounds?
    @x.negative? || @y.negative? || @x >= MAX_X || @y >= MAX_Y 
  end
end

def antinodes(nodes)
  node1, node2 = nodes
  distance_x = (node2.x - node1.x)
  distance_y = (node2.y - node1.y)
  a1 = Node.new(node1.x - distance_x, node1.y - distance_y)
  a2 = Node.new(node2.x + distance_x, node2.y + distance_y)

  [a1, a2]
end

all_antinodes = []

antennae.each do |_frequency, antennas|
  antennas = antennas.map { Node.new(_1.first, _1.last) }
  antinodes = antennas.combination(2).flat_map { antinodes(_1) }
  all_antinodes << antinodes.reject(&:out_of_bounds?)
end

all_antinodes.flatten!
puts all_antinodes.uniq{ [_1.x, _1.y] }.count
