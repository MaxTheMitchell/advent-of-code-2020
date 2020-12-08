class Bag
  attr_accessor :color, :children, :parents

  def initialize(color)
    @color = color
    @children = []
    @parents = []
  end

  def to_s
    "bag with color: #{color}"
  end

  def all_parents
    return self if @parents == []
    (@parents.map { |p| p.all_parents } << self).flatten.uniq
  end

  def all_children
    return self if @children == []
    (@children.map { |c| c.all_children } << self).flatten
  end
end

class Bags
  attr_accessor :bags

  def initialize
    @bags = []
  end

  def get_bag(color)
    b = @bags.find { |b| b.color == color }
    return b unless b == nil
    @bags << Bag.new(color)
    @bags[-1]
  end
end

def read_input
  File.new("./input.txt").read.split("\n")
end

def parse_color_parent(input)
  input.split(" bags contain ")[0][/\S+\s\S+/]
end

def parse_color_children(input)
  return [] if input.split(" bags contain")[1] == " no other bags."
  input.split(" bags contain")[1]
    .split(",")
    .map { |b| [b[3..].split(" bag")[0][/\S+\s\S+/]] * b[/\d+/].to_i }.flatten
end

def make_bags(input)
  bags = Bags.new
  input.each do |i|
    parse_color_children(i).each do |c|
      bags.get_bag(c).parents << bags.get_bag(parse_color_parent(i))
    end
    bags.get_bag(parse_color_parent(i)).children = parse_color_children(i).map { |c| bags.get_bag(c) }
  end
  bags
end

def all_bags(bags)
    bags.get_bag("shiny gold").all_children.length - 1
end

if __FILE__ == $0
  puts all_bags(make_bags(read_input))
end
