require 'debug'

disk = File.readlines('input.txt', chomp: true).map(&:chars).flatten.map(&:to_i)

files = []
gaps = []
file_index = 0
pointer_index = 0
disk.each_with_index do |length, index|
  if index.even?
    files << { fno: file_index, pos: pointer_index, size: length }
    file_index += 1
  else
    gaps << { pos: pointer_index, size: length }
  end
  pointer_index += length
end

defragged_disk = (0...pointer_index).map do |index|
  gap = gaps.find{ |g| (g[:pos]...(g[:pos] + g[:size])).include?(index) }
  if files.empty?
    0
  elsif !gap.nil?
    f = files.last

    if f[:size] == 1
      files = files[...-1]
      f[:fno]
    else
      files[files.size - 1] = { fno: f[:fno], pos: f[:pos], size: f[:size] - 1}
      f[:fno]
    end
  else
    f = files.find { |f| (f[:pos]...(f[:pos] + f[:size])).include?(index) }
    f_index = files.index(f)
    if f[:size] == 1
      files = files[1..]
    else
      files[f_index] = { fno: f[:fno], pos: f[:pos] + 1, size: f[:size] - 1 }
    end
    f[:fno]
  end
end

puts defragged_disk.map.with_index{ |value, index| value * index }.sum