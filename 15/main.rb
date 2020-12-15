def input
  "19,0,5,1,10,13"
end

def read_input
  input.split(",")
end

def parse_input(input)
  return_val = {}
  input.each_with_index do |v, i|
    return_val[v.to_i] = i
  end
  return_val
end

def play_game(nums, target_round)
  current_key = 0
  (nums.length...target_round).each do |i|
    if nums[current_key].nil?
      next_key = 0
    else
      next_key = i - nums[current_key]
    end
    nums[current_key] = i
    current_key = next_key
  end
  nums.key(target_round - 1)
end

# silver
puts play_game(parse_input(read_input), 2020)
# gold
puts play_game(parse_input(read_input), 30000000)
