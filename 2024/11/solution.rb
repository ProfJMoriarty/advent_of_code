# read stones
stones = File.readlines('input.txt', chomp: true).map(&:split).flatten.map(&:to_i)

@memo_stones = {}

# blink
def blink(stones)
  new_stones = []

  stones.each do |stone|
    new_stone =
      if @memo_stones.key?(stone)
        @memo_stones[stone]
      elsif stone.zero?
        1
      elsif stone.to_s.length.even?
        stone1 = stone.to_s[...stone.to_s.length / 2]
        stone2 = stone.to_s[stone.to_s.length / 2..]
        [stone1.to_i, stone2.to_i]
      else
        stone * 2024
      end

    @memo_stones[stone] = new_stone unless @memo_stones.key?(stone)
    new_stones << new_stone
  end

  new_stones.flatten
end

75.times do |i| 
  print "#{i} of 75 \r"
  stones = blink(stones)
end
puts "\n"
puts stones.count