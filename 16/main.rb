def input
  File.new("./input.txt").read
end

def parsed_input
  input.split("\n\n")
end

def get_range(input)
  (input.split("-")[0].to_i..input.split("-")[1].to_i)
end

def get_rules(input = parsed_input[0])
  rules = {}
  input.split("\n").each do |l|
    rules[l.split(":")[0]] = [get_range(l.split(":")[1].split(" ")[0]), get_range(l.split(":")[1].split(" ")[2])]
  end
  rules
end

def get_my_ticket(input = parsed_input[1])
  input.split("\n")[1].split(",").map(&:to_i)
end

def get_random_tickets(input = parsed_input[2])
  input.split("\n")[1..].map do |t|
    t.split(",").map(&:to_i)
  end
end

def invaild_vals(rules, ticket)
  ticket.reject do |t|
    rules.values.any? do |r|
      r.any? { |range| range.include?(t) }
    end
  end
end

def vaild_ticket?(rules, ticket)
  ticket.all? do |t|
    rules.values.any? do |r|
      r.any? { |range| range.include?(t) }
    end
  end
end

def order_rules(rules, tickets)
  ordered_rules = []
  tickets.first.length.times do |i|
    ordered_rules << rules.values.filter do |r|
      tickets.all? { |t| r.any? { |range| range.include?(t[i]) } }
    end.map { |v| rules.key(v) }
  end
  reduce_rules(ordered_rules)
end

def reduce_rules(rules)
  return rules.flatten if rules.all? { |r| r.length == 1 }
  rules.each_with_index
    .filter { |r, i| r.length == 1 }
    .each do |r|
    rules.each_with_index { |r2, i2| r2.delete(r[0][0]) unless r[1] == i2 }
  end
  reduce_rules(rules)
end

def solve_silver
  get_random_tickets.map { |t| invaild_vals(get_rules, t) }.flatten.sum
end

def solve_gold
  rules = get_rules
  rules = order_rules(rules, get_random_tickets.filter { |t| vaild_ticket?(rules, t) })
  get_my_ticket
    .each_with_index
    .filter_map { |t, i| t if rules[i][/departure/] }
    .reduce(&:*)
end

puts solve_silver
puts solve_gold
