require "set"

class Board
  def initialize(layor_0)
    @cubes = layor_0.split("\n")
      .each_with_index
      .filter_map { |row, y| row.chars.each_with_index.filter_map { |a, x| Cube.new([x, y, 0, 0], a == "#") } }
      .flatten
      .map { |c| [c.position, c] }
      .to_h
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
    adj_pos(*cube.position).map { |pos| get_cube_by_pos(pos) }
  end

  def get_cube_by_pos(pos)
    @cubes[pos] || (@cubes[pos] = Cube.new(pos))
  end

  def adj_pos(x, y, z, w)
    adjs = (x - 1..x + 1).map do |pos_x|
      (y - 1..y + 1).map do |pos_y|
        (z - 1..z + 1).map do |pos_z|
          (w - 1..w + 1).map do |pos_w|
            [pos_x, pos_y, pos_z, pos_w]
          end
        end
      end
    end.flatten(3)
      .reject { |p| p == [x, y, z, w] }
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
    @active_next_round = (active_neighbors == 3 or (@active and active_neighbors == 2))
  end

  def set_active
    @active = @active_next_round
  end

  def active_neighbors
    @neighbors.count(&:active)
  end

  def max_neighbors
    (3 ** position.length) - 1
  end
end

def input
  File.new("./input.txt").read
end

def solve_gold
  b = Board.new(input)
  6.times { b.play_round }
  b.active_cube_count
end

puts solve_gold
