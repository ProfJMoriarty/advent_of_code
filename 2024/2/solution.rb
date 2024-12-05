counter = 0

def safe?(arr)
  safe = true
  asc = arr[0] < arr[1]
  arr.each_with_index do |num, index|
    next if index.zero?
    
    diff = (num - arr[index - 1]).abs
    c1 = diff  > 0 && diff < 4
    c2 = (arr[index - 1] < num) == asc
    
    unless c1 && c2
      safe = false
      break
    end
  end
  safe
end


File.readlines('input.txt', chomp: true).each do |line|
  arr = line.split(' ').map(&:to_i)
  if safe?(arr)
    # part 1
    counter += 1
  else
    # part 2
    safe = false
    arr.length.times do |i|
      safe = true if safe?(arr.reject.with_index{|_, j| i == j})
      break if safe
    end

    counter += 1 if safe
  end
end

puts counter
