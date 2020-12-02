def read_input
  File.new("./input.txt").read
end

def find_sol(a)
  a.each do |i|
    a.each do |n|
      a.each do |b|
        return i * n * b if i + n + b == 2020
      end
    end
  end
end

def split_input(input)
  input.split("\n").map { |a| a.to_i }
end

# puts find_sol(s[1721,979,366,299,675,1456])
puts find_sol(
  split_input(
    read_input
  )
)
