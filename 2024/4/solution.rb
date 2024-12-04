require 'debug'

def diagonals(matrix)
  rows = matrix.size
  cols = matrix.first.size
  mirrored_matrix = matrix.map(&:reverse)

  nw_se = Hash.new { |hash, key| hash[key] = [] }
  sw_ne = Hash.new { |hash, key| hash[key] = [] }

  (0...rows).each do |row|
    (0...cols).each do |col|
      nw_se[row - col] << matrix[row][col]
      sw_ne[row - col] << mirrored_matrix[row][col]
    end
  end

  [nw_se.values, sw_ne.values]
end

input_horizontal = File.readlines('input.txt', chomp: true).map(&:chars)
input_vertical = input_horizontal.transpose
input_diagonal_nw_se, input_diagonal_sw_ne = diagonals(input_horizontal)

axes = [input_horizontal, input_vertical, input_diagonal_nw_se, input_diagonal_sw_ne]

xmas_counter = 0
axes.each do |axis|
  axis.each do |line|
    next if line.length < 4
    xmas_counter += line.join.scan(/XMAS/).count
    xmas_counter += line.reverse.join.scan(/XMAS/).count
  end
end
 
puts xmas_counter

# part 2

x_mas_counter = 0
input_horizontal.each_with_index do |line, i|
  line.each_with_index do |char, j|
    next if i.zero? || i == input_horizontal.size - 1
    next if j.zero? || j == line.size - 1
    next unless char == 'A'

    nw_se = [input_horizontal[i - 1][j - 1], char, input_horizontal[i + 1][j + 1]]
    sw_ne = [input_horizontal[i - 1][j + 1], char, input_horizontal[i + 1][j - 1]]

    x_mas_counter += 1 if (nw_se.join == 'MAS' || nw_se.reverse.join == 'MAS') && (sw_ne.join == 'MAS' || sw_ne.reverse.join == 'MAS')
  end
end

puts x_mas_counter