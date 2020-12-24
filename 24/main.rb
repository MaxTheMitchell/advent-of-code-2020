require "set"

class Board
  def initialize(positions)
    @cubes = positions.map { |p| [p, Cube.new(p, true)] }.to_h
  end

  def play_round
    add_neighbors
    @cubes.values.each(&:set_will_be_active)
    @cubes.values.each(&:set_active)
  end

  def active_cube_count
    active_cubes.length
  end

  def add_neighbors
    active_cubes.reject(&:has_set_neighbors?).each do |c|
      c.neighbors += cube_neighbors(c)
      c.set_neighbors
    end
  end

  def cube_neighbors(cube)
    adj_pos(cube.position).map { |pos| get_cube_by_pos(pos) }
  end

  def get_cube_by_pos(pos)
    @cubes[pos] || (@cubes[pos] = Cube.new(pos))
  end

  def adj_pos(position)
    [[-1, 0, 1], [0, 1, 1], [1, 1, 0], [1, 0, -1], [0, -1, -1], [-1, -1, 0]].map do |pos|
      pos.each_with_index.map { |v, i| position[i] + pos[i] }
    end
  end

  def active_cubes
    @cubes.values.filter(&:active)
  end
end

class Cube
  attr_accessor :position, :neighbors, :active

  def initialize(position, active = false, neighbors = Set[])
    @position = position
    @active = active
    @neighbors = neighbors
    @active_next_round = false
  end

  def has_set_neighbors?
    neighbors.length == max_neighbors
  end

  def set_neighbors
    @neighbors.each { |n| n.neighbors << self }
  end

  def set_will_be_active
    @active_next_round = (active_neighbors == 2 or (@active and active_neighbors == 1))
  end

  def set_active
    @active = @active_next_round
  end

  def active_neighbors
    @neighbors.count(&:active)
  end

  def max_neighbors
    6
  end
end

def input
  File.new("input.txt").read
end

def parsed_input
  input.split("\n").map do |l|
    previous = ""
    l.chars.filter_map do |c|
      if c[/[we]/]
        return_val = previous + c
        previous = ""
      else
        previous = c
        return_val = nil
      end
      return_val
    end
  end
end

def find_pos(path)
  pos = [0, 0, 0]
  path.each do |p|
    case p
    when "e"
      pos[0] += 1
      pos[1] += 1
    when "ne"
      pos[1] += 1
      pos[2] += 1
    when "se"
      pos[0] += 1
      pos[2] -= 1
    when "nw"
      pos[0] -= 1
      pos[2] += 1
    when "w"
      pos[0] -= 1
      pos[1] -= 1
    when "sw"
      pos[1] -= 1
      pos[2] -= 1
    end
  end
  pos
end

def solve_silver
  positions = parsed_input.map { |i| find_pos(i) }
  positions.uniq.map { |p| positions.count(p) }.count { |o| o % 2 == 1 }
end

def solve_gold
  positions = parsed_input.map { |i| find_pos(i) }
  black_tiles = positions.uniq.filter { |p| positions.count(p) % 2 == 1 }
  b = Board.new(black_tiles)
  100.times { b.play_round }
  b.active_cube_count
end

puts solve_silver
puts solve_gold
