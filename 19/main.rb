def input
  File.new("./input.txt").read
end

def parsed_input
  input.split("\n\n")
end

def parse_rule(rule)
  return rule.split('"')[1] unless rule[/\d/]
  rule.split("|").map do |r|
    r.split(" ").map(&:to_i)
  end
end

def rules
  parsed_input[0].split("\n").map do |r|
    [
      r.split(":")[0].to_i,
      parse_rule(r.split(": ")[1]),
    ]
  end.to_h
end

def lines
  parsed_input[1].split("\n")
end

def rules_to_regex(rules, index = 0)
  return rules[index] if ["a", "b"].include?(rules[index])
  "(
  #{rules[index].each_with_index.map do |r, c|
    del = r.delete(index)
    looping = case del
      when 8
        "+"
      when 11
        "{1}"
      else
        ""
      end
    "#{"|" if c % 2 == 1}
    #{r.map { |i| rules_to_regex(rules, i) }.join(looping)}#{looping}"
  end.join("")})"
end

def solve_silver
  regex = Regexp.new("^#{rules_to_regex(rules).split(/\s/).join("")}$")
  lines.count { |l| l[regex] }
end

def solve_gold
  rs = rules
  rs[8] = [[42], [42, 8]]
  rs[11] = [[42, 31], [42, 11, 31]]
  regex_template = "^#{rules_to_regex(rs).split(/\s/).join("")}$"
  regex_alts = (1..100).map { |i| Regexp.new(regex_template.split("1").join(i.to_s)) }
  lines.count { |l| regex_alts.any? { |r| l[r] } }
end

puts solve_silver
puts solve_gold
