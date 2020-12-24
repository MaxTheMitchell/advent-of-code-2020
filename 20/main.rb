def input
  File.new("input.txt").read
end

def parsed_input
  input.split("\n\n")
end

class Image
  SEA_MONSTER = {
    positions: [[18, 0], [0, 1], [5, 1], [6, 1], [11, 1], [12, 1], [17, 1], [18, 1], [19, 1], [1, 2], [4, 2], [7, 2], [10, 2], [13, 2], [16, 2]],
    width: 20,
    height: 3,
  }
  attr_accessor :tiles

  def initialize(tiles)
    @tiles = tiles
  end

  def set_neighbors
    @tiles.each do |tile|
      @tiles.each do |t|
        tile.neighbors << t if tile.shares_any_edge?(t) and tile != t
      end
    end
  end

  def orantate(orantated = [corners[0]])
    return nil if orantated?
    to_orantate = orantated.map { |o| o.neighbors }.flatten.uniq.reject { |n| orantated.include?(n) }
    to_orantate.each { |o| o.orantate(o.neighbors & orantated) }
    orantate(orantated + to_orantate)
  end

  def set_positions
    corners[0].set_axis_start
    until positions_set?
      @tiles.filter(&:can_set_position?).each(&:set_position)
    end
  end

  def orantated?
    @tiles.all?(&:orantated?)
  end

  def positions_set?
    @tiles.all?(&:has_position?)
  end

  def corners
    @tiles.filter(&:is_corner?)
  end

  def rough_water
    total_hashtags - SEA_MONSTER[:positions].length * locate_sea_monsters
  end

  def total_hashtags
    @tiles.sum { |t| t.data.length }
  end

  def locate_sea_monsters
    tile = @tiles[0]
    i = 0
    until i > 4
      i += 1
      return sea_monsters(tile) if sea_monsters(tile) != 0
      tile.rotate!
    end
    tile.flip!
    until sea_monsters(tile) != 0
      tile.rotate!
    end
    sea_monsters(tile)
  end

  def sea_monsters(tile)
    (0...tile.size - SEA_MONSTER[:width]).sum do |x|
      (0...tile.size - SEA_MONSTER[:height]).count do |y|
        SEA_MONSTER[:positions].all? { |pos| tile.data.include?([pos[0] + x, pos[1] + y]) }
      end
    end
  end

  def remove_edges!
    @tiles.each(&:remove_edges!)
  end

  def join_tiles!
    @tiles = [
      Tile.new(
        @tiles.map { |t| t.positioned_data }.flatten(1),
        (@tiles.length ** 0.5).to_i * 8 - 1
      ),
    ]
  end

  def anything_at_position?(pos)
    @tiles.find { |t| t.within?(pos) }.anything_at?(pos)
  end

  def size
    (@tiles[0].size + 1) * amount_of_tile_axis
  end

  def amount_of_tile_axis
    (tiles.length ** 0.5).to_i
  end

  def get_tile_at_pos(pos)
    tiles.find { |t| t.position == pos }
  end
end

class Tile
  attr_accessor :neighbors, :id, :data, :all_edges, :all_inverted_edges, :position, :size

  def initialize(data, size = 9, neighbors = [])
    @size = size
    if data.is_a?(String)
      @id = data[/\d+/].to_i
      @data = data.split("\n")[1..].each_with_index.map do |row, y|
        row.chars.each_with_index.filter_map { |v, x| [x, y] if v == "#" }
      end.flatten(1)
    else
      @data = data
    end
    @neighbors = neighbors
    @all_edges = make_all_edges
    @all_inverted_edges = make_all_edges(inverted_edges)
    @position = nil
  end

  def positioned_data
    @data.map do |d|
      [
        d[0] + position[0] * (@size + 1),
        d[1] + position[1] * (@size + 1),
      ]
    end
  end

  def shares_any_edge?(tile)
    not shared_edges_any(tile)[0].nil?
  end

  def shared_edges_any(tile)
    (tile.all_inverted_edges & all_edges)
  end

  def shares_edge?(tile)
    not shared_edge(tile).nil?
  end

  def shared_edge(tile)
    edge = (tile.inverted_edges.each_with_index.to_a & edges.each_with_index.to_a)
    edge == [] ? nil : edge[0]
  end

  def orantate(orantate_to)
    i = 0
    until orantate_to.all? { |o| shares_edge?(o) } or i > 4
      i += 1
      rotate!
    end
    return nil if orantate_to.all? { |o| shares_edge?(o) }
    flip!
    until orantate_to.all? { |o| shares_edge?(o) }
      rotate!
    end
  end

  def has_position?
    not @position.nil?
  end

  def set_axis_start
    @position = [0, 0]
    neighbors[0].set_axis([1, 0])
    neighbors[1].set_axis([0, 1])
  end

  def set_axis(position)
    @position = position
    unless is_corner?
      neighbors.find { |n| not(n.has_position? or n.is_center?) }.set_axis(position.map { |p| p == 0 ? 0 : p + 1 })
    end
  end

  def can_set_position?
    not has_position? and neighbors.count(&:has_position?) == 2
  end

  def set_position
    @position = [
      neighbors.filter(&:has_position?).map(&:position).map(&:first).max,
      neighbors.filter(&:has_position?).map(&:position).map(&:last).max,
    ]
  end

  def orantated?
    neighbors.all? { |n| shares_edge?(n) }
  end

  def is_corner?
    neighbors.length == 2
  end

  def is_edge?
    neighbors.length == 3
  end

  def is_center?
    neighbors.length == 4
  end

  def make_all_edges(all_e = edges)
    (0..2).each { |i| all_e += all_e[i * 4..].map { |e| rotate_edge(e) } }
    all_e += all_e.map { |e| flip_edge(e) }
    all_e.map { |e| e.sort }
  end

  def rotate!
    @data.map! { |pos| rotate_pos(pos) }
  end

  def flip!
    @data.map! { |pos| flip_pos(pos) }
  end

  def remove_edges!
    @data.reject! { |d| edges.flatten(1).include?(d) }
    @data.map! { |d| d.map { |p| p - 1 } }
    @size = 7
  end

  def flip_edge(edge)
    edge.map { |pos| flip_pos(pos) }
  end

  def rotate_edge(edge)
    edge.map { |pos| rotate_pos(pos) }
  end

  def rotate_my_position!
    @position = rotate_pos(@position)
  end

  def flip_my_position!
    @position = flip_pos(@position)
  end

  def rotate_pos(pos)
    [pos[1], (pos[0] - @size).abs]
  end

  def flip_pos(pos)
    [pos[0], (pos[1] - @size).abs]
  end

  def edges
    [
      @data.filter { |d| d[0] == 0 },
      @data.filter { |d| d[0] == @size },
      @data.filter { |d| d[1] == 0 },
      @data.filter { |d| d[1] == @size },
    ].map { |e| e.sort }
  end

  def inverted_edges
    e = edges
    [
      e[1].map { |d| [0, d[1]] },
      e[0].map { |d| [@size, d[1]] },
      e[3].map { |d| [d[0], 0] },
      e[2].map { |d| [d[0], @size] },
    ]
  end

  def to_s
    puts position.to_s
    puts id
    (0..@size).each do |y|
      puts (0..@size).map { |x| @data.include?([x, y]) ? "#" : "." }.join("")
    end
    puts
  end
end

def solve_silver
  img = Image.new(parsed_input.map { |i| Tile.new(i) })
  img.set_neighbors
  img.corners.map(&:id).reduce(&:*)
end

def solve_gold
  img = Image.new(parsed_input.map { |i| Tile.new(i) })
  img.set_neighbors
  img.orantate
  img.set_positions
  img.remove_edges!
  img.tiles.each(&:rotate!)
  img.tiles.each(&:flip!)
  img.join_tiles!
  img.rough_water
end

puts solve_silver
puts solve_gold
