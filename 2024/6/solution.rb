require 'debug'

map1518 = File.readlines('input.txt', chomp: true).map(&:chars)
map1518 = map1518
guardian_row = map1518.find { _1.include?('^')}
guardian_pos_x, guardian_pos_y = [guardian_row.index('^'), map1518.index(guardian_row)]

def guard_on_map?(map, x, y)
  (0...map.first.size).include?(x) && (0...map.size).include?(y)
end

def in_front(map, x, y, direction)
  dir = direction % 4
  case dir
  when 0 # up
    return '0' if (y - 1).zero?
    map[y - 1][x]
  when 1 # right
    return '0' if (x - 1) >= map.first.size
    map[y][x + 1]
  when 2 # down
    return '0' if (y + 1) >= map.size
    map[y + 1][x]
  when 3 # left
    return '0' if (x - 1).zero?
    map[y][x - 1]
  end
end

def move(direction, x, y)
  dir = direction % 4
  case dir
  when 0 # up
    y -= 1
  when 1 # right
    x += 1
  when 2 # down
    y += 1
  when 3 # left
    x -= 1
  end

  [x, y]
end

# used for part 2
trodded_path = []

direction = 0 # up
while guard_on_map?(map1518, guardian_pos_x, guardian_pos_y)
  in_front_of_guard = in_front(map1518, guardian_pos_x, guardian_pos_y, direction)
  if in_front_of_guard != '#'
    map1518[guardian_pos_y][guardian_pos_x] = 'X'
    trodded_path << [guardian_pos_x, guardian_pos_y, direction % 4]
    guardian_pos_x, guardian_pos_y = move(direction, guardian_pos_x, guardian_pos_y)
  else
    direction += 1
  end
end

trodded_path.uniq

puts map1518.map{ _1.count('X') }.sum

# part 2 (brute force, not working)
guardian_pos_x, guardian_pos_y = [guardian_row.index('^'), map1518.index(guardian_row)]

def got_stuck?(map, x, y, direction)
  visited_spaces = { 0 => [], 1 => [], 2 => [], 3 => [] }
  while guard_on_map?(map, x, y) && !visited_spaces[direction % 4].include?([x, y])
    in_front_of_guard = in_front(map, x, y, direction)
    if in_front_of_guard != '#'
      visited_spaces[direction % 4] << [x, y]
      x, y = move(direction, x, y)
    else
      direction += 1
    end
  end
  guard_on_map?(map, x, y)
end

looping_obstacles = 0
obstacled_positions = []
trodded_path.each_with_index do |coordinates, index|
  next if index.zero?
  x, y, dir = coordinates
  next unless map1518[x][y] == 'X'
  next if obstacled_positions.include?([x, y])

  
  map1518[x][y] = '#'
  start_x, start_y = trodded_path[index - 1]
  looping_obstacles += 1 if got_stuck?(map1518, start_x, start_y, dir)
  print "found #{looping_obstacles} in #{index} / #{trodded_path.size - 1} labs\r"
  map1518[x][y] = 'X'
end
# 4910 too high
# 1084 too low

puts "\n"
puts looping_obstacles