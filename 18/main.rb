def input
  File.new("./input.txt").read
end

def parsed_input
  input.split("\n").map do |e|
    equation = []
    target = equation
    previous_targets = []
    e.chars.reject { |c| c == " " }.each do |c|
      case c
      when "("
        previous_targets << target
        target = (target << []).last
      when ")"
        target = previous_targets.pop
      when /\d/
        target << c.to_i
      else
        target << c
      end
    end
    equation
  end
end

def solve_equation_silver(equation)
  equation = equation[0] if equation.is_a?(Array) and equation.length == 1
  return equation if equation.is_a?(Integer)
  case equation[1]
  when "+"
    new_val = solve_equation_silver(equation[0]) + solve_equation_silver(equation[2])
  when "*"
    new_val = solve_equation_silver(equation[0]) * solve_equation_silver(equation[2])
  end
  solve_equation_silver(equation[3..].unshift(new_val))
end

def solve_equation_gold(equation)
  equation = equation[0] if equation.is_a?(Array) and equation.length == 1
  return equation if equation.is_a?(Integer)
  if (index = equation.find_index("+")).nil?
    new_val = solve_equation_gold(equation[0]) * solve_equation_gold(equation[2])
    return solve_equation_gold(equation[3..].unshift(new_val))
  else
    new_val = solve_equation_gold(equation[index - 1]) + solve_equation_gold(equation[index + 1])
    return solve_equation_gold(equation[...index - 1] + [new_val] + equation[index + 2..])
  end
end

def solve_silver
  parsed_input.sum { |e| solve_equation_silver(e) }
end

def solve_gold
  parsed_input.sum { |e| solve_equation_gold(e) }
end

puts solve_silver
puts solve_gold
