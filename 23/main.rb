class LinkedList
  def initialize(values)
    @nodes = []
    child = nil
    end_node = nil
    values.reverse.each_with_index do |v, i|
      child = Node.new(v, child)
      end_node = child if i == 0
      @nodes[v] = child
    end
    end_node.child = child
    @current_node = child
  end

  def play_round
    three_cups = 3.times.map { @current_node.pop }
    target = @current_node.value - 1
    while three_cups.map(&:value).include?(target) or target <= 0
      target -= 1
      target = @nodes.length - 1 if target <= 0
    end
    target = get_node(target)
    three_cups.each do |c|
      target.add(c)
      target = c
    end
    @current_node = @current_node.child
  end

  def get_node(val)
    @nodes[val]
  end
end

class Node
  attr_accessor :child, :value

  def initialize(value, child = nil)
    @value = value
    @child = child
  end

  def add(node)
    old_child = child
    @child = node
    @child.child = old_child
  end

  def pop
    old_child = child
    @child = old_child.child
    old_child.child = nil
    old_child
  end

  def tail
    return self if child.nil?
    child.tail
  end

  def to_s
    to_a.join("")
  end

  def to_a(nodes = [])
    if nodes.include?(self)
      return nodes.map(&:value)
    elsif child == nil
      return nodes.map(&:value) << value
    end
    child.to_a(nodes << self)
  end
end

def input
  "925176834"
end

def parsed_input
  input.chars.map(&:to_i)
end

def gold_input
  (input.chars.map(&:to_i) + (10..1000000).to_a)
end

def solve_silver
  ll = LinkedList.new(parsed_input)
  100.times { ll.play_round }
  puts ll.get_node(1).to_s
end

def solve_gold
  ll = LinkedList.new(parsed_input + (10..1000000).to_a)
  10000000.times { ll.play_round }
  node_one = ll.get_node(1)
  puts node_one.child.value * node_one.child.child.value
end

# solve_silver
solve_gold
