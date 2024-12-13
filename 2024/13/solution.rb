require 'debug'

entries = []

File.readlines('input.txt', chomp: true).each do |line|
  if line.start_with?('Button A:')
    ax = line.split(':').last.split(',').first.split('+').last.to_i
    ay = line.split(':').last.split(',').last.split('+').last.to_i
    entries << { prize: [], a: [ax, ay], b: 0 }
  elsif line.start_with?('Button B:')
    bx = line.split(':').last.split(',').first.split('+').last.to_i
    by = line.split(':').last.split(',').last.split('+').last.to_i
    entries.last[:b] = [bx, by]
  elsif line.start_with?('Prize:')
    x = line.split(':').last.split(',').first.split('=').last.to_i
    y = line.split(':').last.split(',').last.split('=').last.to_i
    entries.last[:prize] = [x, y]
  end
end

def winning_ways(entry)
  winners = []
  px, py = entry[:prize]
  ax, ay = entry[:a]
  bx, by = entry[:b]
  # no more than 100 presses of each button
  max_a = [(px / ax).floor, 100, (py / ay).floor].sort.first
  max_b = [(px / bx).floor, 100, (py / by).floor].sort.first  
  
  (0..max_b).to_a.reverse.each do |y|
    (0..max_a).to_a.reverse.each do |x|
      # find x and y such that
      next unless px == (x * ax) + (y * bx)
      next unless py == (x * ay) + (y * by)

      winners << [y, x]
    end
  end

  winners
end

def cheapest_way_to_prize(entry)
  winners = winning_ways(entry)
  return 0 if winners.empty?
  
  y, x = winners.sort.reverse.first
  x * 3 + y
end

cost_in_tokens = entries.map { cheapest_way_to_prize(_1) }.sum

puts cost_in_tokens



