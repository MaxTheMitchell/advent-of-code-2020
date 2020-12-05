def read_input
  File.new("./input.txt")
      .read
      .split("\n")
end

def find_row(input, vals = (0...128).to_a)
  return vals[0] unless input[/[FB]/]
  return find_row(input[1..], vals[..vals.length / 2]) if input[0] == "F"
  find_row(input[1..], vals[vals.length / 2..])
end

def find_col(input, vals = (0...8).to_a)
  return vals[0] unless input[/[LR]/]
  return find_col(input[1..], vals[..vals.length / 2]) if input[0] == "L"
  find_col(input[1..], vals[vals.length / 2..])
end

def seat_id(row, col)
  row * 8 + col
end

def get_id(input)
  seat_id(find_row(input), find_col(input[/[LR]+/]))
end

def get_all_ids
  read_input.map { |i| get_id(i) }
end

def all_possible_ids
  (0...128).map do |row|
    (0...8).map do |col|
      seat_id(row, col)
    end
  end.flatten(1)
end

taken_ids = get_all_ids
puts all_possible_ids
       .filter { |id| not taken_ids.include?(id) }
       .filter { |id| taken_ids.include?(id - 8) }
       .find { |id| taken_ids.include?(id + 8) }
