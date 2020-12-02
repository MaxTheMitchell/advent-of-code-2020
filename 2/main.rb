def read_input
  File.new("./input.txt").read.split("\n")
end

def get_range(input)
    [input.split("-")[0].to_i,input.split("-")[1].split(" ")[0].to_i]
end

def get_char(input)
    input.split(" ")[1][0]
end

def get_password(input)
    input.split(" ")[2]
end

def is_valid?(input)
    password = get_password(input)
    [
        password[get_range(input)[0]-1],
        password[get_range(input)[1]-1],
    ].filter {|p| p == get_char(input)}.length == 1
end

puts read_input
    .filter { |i| is_valid?(i) }
    .length
