def read_input
  File.new("input.txt").read.split("\n\n")
end

def yeses(input)
  peeps = input.split("\n")
  input.split("")
    .filter { |i| not i[/\s/] }
    .uniq
    .filter { |i| peeps.all? { |p| p[/#{i}/] } }
    .length
end

puts read_input.map { |n| yeses(n) }.sum
