lines = File.readlines('input.txt', chomp: true)
left_list = []
right_list = []
lines.each do |line|
  left, right = line.split(' ').map(&:to_i)
  left_list << left
  right_list << right
end

left_list.sort!
right_list.sort!

diff = 0
left_list.length.times do |i|
  diff += (left_list[i] - right_list[i]).abs
end

puts diff

# part 2

similarity = 0
tallied_right_list = right_list.tally
left_list.length.times do |i|
  next unless tallied_right_list.key?(left_list[i])
  similarity += left_list[i] * tallied_right_list[left_list[i]]
end

puts similarity