require 'debug'

rules = Hash.new { |hash, key| hash[key] = [] }
updates = []
File.readlines('input.txt', chomp: true).each do |line|
  next if line.empty?

  if line.include? '|'
    page, before = line.split('|').map(&:to_i)
    rules[page] << before
  else
    updates << line.split(',').map(&:to_i)
  end
end

def passes_rules?(arr, rules)
  arr.each_with_index.all? do |page, index|
    if rules[page].nil?
      true
    else
      rules[page].all? { |before| !arr[...index].include?(before) }
    end
  end
end

correct_updates = []
incorrect_updates = []
updates.each do |update|
  if passes_rules?(update, rules)
    correct_updates << update
  else
    incorrect_updates << update
  end
end

sum = correct_updates.map { |pages| pages[((pages.size - 1) / 2)] }.reduce(:+)
puts sum

# part 2

def fix_ordering(arr, rules)
  until passes_rules?(arr, rules)
    rule_index = 0
    rule_breaking_index = 0
    arr.each_with_index do |page, index|
      rule_breaker = rules[page].find { |before| arr[...index].include?(before) }
      next if rule_breaker.nil?

      rule_breaking_index = arr.index(rule_breaker)
      rule_index = index
      break
    end
    arr = arr.insert(rule_index + 1, arr[rule_breaking_index])
    arr.delete_at(rule_breaking_index)
  end
  arr
end

incorrect_updates = incorrect_updates.map {|update| fix_ordering(update, rules) }
sum2 = incorrect_updates.map { |pages| pages[((pages.size - 1) / 2)] }.reduce(:+)

puts sum2