def read_input
  File.new("./input.txt").read.split("\n")
end

def get_inst(move, dir)
  return get_dir(dir) if move[0] == "F"
  move[0]
end

def get_val(move)
  move[1..].to_i
end

def get_dir(deg)
  case deg.abs % 360
  when 0
    "E"
  when 90
    "S"
  when 180
    "W"
  when 270
    "N"
  end
end

def move_ship(input, pos = [0, 0], dir = 0)
  return pos if input == []
  val = get_val(input[0])
  case get_inst(input[0], dir)
  when "N"
    move_ship(input[1..], [pos[0], pos[1] + val], dir)
  when "S"
    move_ship(input[1..], [pos[0], pos[1] - val], dir)
  when "E"
    move_ship(input[1..], [pos[0] + val, pos[1]], dir)
  when "W"
    move_ship(input[1..], [pos[0] - val, pos[1]], dir)
  when "L"
    move_ship(input[1..], pos, dir + (360 - val))
  when "R"
    move_ship(input[1..], pos, dir + val)
  end
end

def rotate_waypoint(waypoint, deg)
  case deg.abs % 360
  when 0
    waypoint
  when 90
    [waypoint[1], waypoint[0] * -1]
  when 180
    [waypoint[0] * -1, waypoint[1] * -1]
  when 270
    [waypoint[1] * -1, waypoint[0]]
  end
end

def move_ship_with_waypoint(input, pos = [0, 0], waypoint = [10, 1])
  return pos if input == []
  val = get_val(input[0])
  case input[0][0]
  when "N"
    move_ship_with_waypoint(input[1..], pos, [waypoint[0], waypoint[1] + val])
  when "S"
    move_ship_with_waypoint(input[1..], pos, [waypoint[0], waypoint[1] - val])
  when "E"
    move_ship_with_waypoint(input[1..], pos, [waypoint[0] + val, waypoint[1]])
  when "W"
    move_ship_with_waypoint(input[1..], pos, [waypoint[0] - val, waypoint[1]])
  when "L"
    move_ship_with_waypoint(input[1..], pos, rotate_waypoint(waypoint, 360 - val))
  when "R"
    move_ship_with_waypoint(input[1..], pos, rotate_waypoint(waypoint, val))
  when "F"
    move_ship_with_waypoint(input[1..], [pos[0] + val * waypoint[0], pos[1] + val * waypoint[1]], waypoint)
  end
end

def solve_silver
  move_ship(read_input).map(&:abs).sum
end

def solve_gold
  move_ship_with_waypoint(read_input).map(&:abs).sum
end

puts solve_silver
puts solve_gold
