master_regex = /(do\(\)|don't\(\)|mul\([0-9]{1,3},+[0-9]{1,3}\))/

operations = []
File.readlines('input.txt', chomp: true).each do |line|
  operations += line.scan(master_regex)
end

operations.flatten!

sum = 0
on = true
operations.each do |exp|
  if exp == 'do()'
    on = true
  elsif exp == "don't()"
    on = false
  elsif on
    numbers = exp.scan(/\d+/).map(&:to_i)
    sum += numbers.inject(:*)
  end
end

puts sum