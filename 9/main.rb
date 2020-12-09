def read_input
  File.new("./input.txt").read.split("\n").map(&:to_i)
end

def is_valid?(val, numbs)
  numbs.combination(2).to_a.map(&:sum).include?(val)
end

def solve_slver(preamble, d)
  (preamble...d.length).each do |i|
    return d[i + 1] unless is_valid?(d[i + 1], d.slice(i - preamble, i))
  end
end

def is_valid_gold?(data, numbs = [])
  return (numbs.max + numbs.min) if (numbs.sum == 1639024365 and numbs.length > 1)
  return nil if numbs.sum > 1639024365
  is_valid_gold?(data[1..], numbs << data[0])
end

def solve_gold(data)
  (0...data.length).each do |i|
    tmp = is_valid_gold?(data[i..])
    return tmp unless tmp == nil
  end
end

puts solve_slver(25, read_input)
puts solve_gold(read_input)
