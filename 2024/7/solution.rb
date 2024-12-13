equations = Hash.new {|hash, key| hash[key] = [] }
File.readlines('input.txt', chomp: true).each do |line|
  test_value = line.split(':').first.to_i
  equation = line.split(':').last.split.map(&:to_i)
  equations[test_value] = equation
end

def valid_equation?(first_term, rest_of_equation, test_value)
  return test_value == first_term if rest_of_equation.empty?

  valid_equation?(first_term + rest_of_equation.first, rest_of_equation[1..], test_value) || 
    valid_equation?(first_term * rest_of_equation.first, rest_of_equation[1..], test_value) ||
      valid_equation?((first_term.to_s + rest_of_equation.first.to_s).to_i, rest_of_equation[1..], test_value)
end

puts equations.filter {|test_value, equation| valid_equation?(equation.first, equation[1..], test_value) }.keys.map(&:to_i).sum 

