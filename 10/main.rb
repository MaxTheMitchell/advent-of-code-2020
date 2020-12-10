def read_input
  File.new("./input.txt").read
end

def parse_input(input)
  input.split("\n").map(&:to_i)
end

def jolt_types(v, vals, jolts = [])
  return jolts if vals == []
  jolt_types(vals.max, vals.reject { |v| v == vals.max }, jolts << (v - vals.max))
end

def solve_silver(vals)
  jolts = jolt_types(vals.max + 3, vals)
  (jolts.count(1) + 1) * jolts.count(3)
end

def combos(vals, used_vals = [[0, 1]])
  return used_vals[-1][1] if vals == []
  combos(vals[1..], used_vals << [vals[0], used_vals.filter { |u| (vals[0] - u[0]).between?(1, 3) }.sum { |u| u[1] }])
end

puts solve_silver(parse_input(read_input))

# gold
puts combos(parse_input(read_input).sort)
