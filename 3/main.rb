
def read_input
  File.new("./input.txt")
    .read
    .split("\n")
end

def hit_tree?(i, a)
  return a[i % a.length] == "#"
end

def find_w_slope(slope, y)
  read_input
    .each_with_index
    .filter { |row, i| hit_tree?(i * slope / y, row) and i % y == 0 }
    .length
end

puts [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
].map { |i| find_w_slope(*i) }.reduce(&:*)
