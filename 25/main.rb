def input 
  File.new("./input.txt").read
end 

def parsed_input
  input.split("\n").map(&:to_i)
end

def transform_subject_number(loop_amount, subj = 7) 
  value = 1
  loop_amount.times do 
    value *= subj
    value %= 20201227
  end
  value
end

def card_loop(card_id, subj = 7)
  value = 1
  loop_val = 0
  while card_id != value do 
    value *= subj
    value %= 20201227
    loop_val += 1
  end
  loop_val
end

def solve_silver 
  puts transform_subject_number(card_loop(parsed_input[1]), parsed_input[0] )
end

solve_silver