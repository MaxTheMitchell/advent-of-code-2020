def read_input
  File.new("./input.txt").read.split("\n").map(&:chars)
end

def adjs(x, y, seats)
  (-1..1).map do |s_x|
    (-1..1).map do |s_y|
      [s_x, s_y] == [0, 0] ? false : in_line_of_sight?([x + s_x, y + s_y], [s_x, s_y], seats)
    end
  end.flatten.count(true)
end

def in_line_of_sight?(pos, slope, seats)
  return false unless (pos[0].between?(0, seats[0].length - 1) and pos[1].between?(0, seats.length - 1)) and seats[pos[1]][pos[0]] != "L"
  return true if seats[pos[1]][pos[0]] == "#"
  in_line_of_sight?(
    [pos[0] + slope[0], pos[1] + slope[1]],
    slope,
    seats,
  )
end

def run(seats, prevous_seats = nil)
  return seats if seats == prevous_seats
  run(
    seats.each_with_index.map do |row, y|
      row.each_with_index.map do |s, x|
        if s == "L" and adjs(x, y, seats) == 0
          "#"
        elsif s == "#" and adjs(x, y, seats) > 4
          "L"
        else
          s
        end
      end
    end,
    seats
  )
end

# gold
puts run(read_input).flatten.count("#")
