def read_input
  File.new("./input.txt").read.split("\n")
end

def parse_ids(ids)
  ids.split(",").reject { |id| id == "x" }.map(&:to_i)
end

def possible_time(id, target, total = 0)
  while total < target
    total += id
  end
  total
end

def parse_ids_gold(ids)
  ids.split(",").each_with_index.filter_map { |id, i| [i, id.to_i] if id != "x" }
end

def is_valid?(time, ids)
  ids.each_with_index.all? { |id, i| id.nil? or ((time + i) % id) == 0 }
end

def mod_inverse(val, mod)
  val %= mod
  (1...mod).find { |i| (val * i) % mod == 1 } || 1
end

def chinese_remainder_theorem(vals)
  m = vals.map(&:last).reduce(&:*)
  cap_m_vals = vals.map { |v| m / v.last }
  vals.length.times.sum do |i|
    vals[i].first * cap_m_vals[i] * mod_inverse(cap_m_vals[i], vals[i].last)
  end % m
end

def find_remainders(vals)
  vals.map { |v| [v[1] - v[0], v[1]] }
end

def solve_silver
  time, ids = read_input
  time = time.to_i
  min_id = parse_ids(ids).min_by { |id| possible_time(id, time) }
  min_id * (possible_time(min_id, time) - time)
end

def solve_gold
  chinese_remainder_theorem(
    find_remainders(
      parse_ids_gold(
        read_input[1]
      )
    )
  )
end

puts solve_silver
puts solve_gold
