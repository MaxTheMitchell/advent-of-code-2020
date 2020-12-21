def input
  File.new("./input.txt").read
end

def parsed_input
  input.split("\n").map do |i|
    [
      i.split(" (")[0].split(" "),
      i.split("(contains ")[1][...-1].split(", "),
    ]
  end.to_h
end

def is_alergic?(hash, ingredant)
  alergies = hash.keys.filter { |k| k.include?(ingredant) }.map { |k| hash[k] }.flatten
  alergies.uniq.any? { |a| alergies.count(a) == amount_of_algeries(hash, a) }
end

def get_alergy(hash, ingredant)
  alergies = hash.keys.filter { |k| k.include?(ingredant) }.map { |k| hash[k] }.flatten
  alergies.uniq.filter { |a| alergies.count(a) == amount_of_algeries(hash, a) }
end

def amount_of_algeries(hash, alergy)
  hash.values.flatten.count(alergy)
end

def reduce_algeries(hash)
  return hash if hash.all? { |k, v| v.length == 1 }
  hash.filter { |k, v| v.length == 1 }.each do |k, v|
    hash.each do |k2, v2|
      hash[k2] = v2.reject { |v3| v3 == v[0] } unless k == k2
    end
  end
  reduce_algeries(hash)
end

def solve_silver
  hash = parsed_input
  hash.keys.flatten.uniq.reject do |ingredant|
    is_alergic?(hash, ingredant)
  end.sum { |a| hash.keys.flatten.count(a) }
end

def solve_gold
  hash = parsed_input
  hash = hash.keys.flatten.uniq.filter do |ingredant|
    is_alergic?(hash, ingredant)
  end.map { |a| [a, get_alergy(hash, a)] }.to_h
  reduce_algeries(hash).sort_by { |k,v| v[0] }.map { |k, v| k }.join(",")
end

puts solve_silver
puts solve_gold
