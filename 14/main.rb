def read_input
  File.new("./input.txt").read.split("\n")
end

def over_wirte_mask(memory, mask)
  memory.reverse!
  mask.chars.reverse.each_with_index.map do |m, i|
    if m != "X"
      m
    elsif memory[i].nil?
      "0"
    else
      memory[i]
    end
  end.reverse.join("")
end

def sum_memory(memory)
  memory.values.sum do |v|
    v.to_i(2)
  end
end

def run_silver(instructions, memory = {}, mask = "X" * 36)
  return memory if instructions == []
  val = instructions[0].split(" = ")[1]
  case instructions[0]
  when /mask/
    run_silver(instructions[1..], memory, val)
  when /mem/
    memory[instructions[0].split(" = ")[0][/\d+/]] = over_wirte_mask(val.to_i.to_s(2), mask)
    run_silver(instructions[1..], memory, mask)
  end
end

def get_address(address, mask)
  xs = []
  addresses = []
  address.reverse!
  addresses[0] = mask.chars.reverse.each_with_index.map do |m, i|
    if m == "X"
      xs << 2 ** i
      "0"
    elsif m == "1"
      "1"
    elsif address[i].nil?
      "0"
    else
      address[i]
    end
  end.reverse.join("").to_i(2)
  (1..xs.length).each do |c|
    addresses << xs.combination(c).map { |c| c.sum + addresses[0] }
  end
  addresses.flatten
end

def run_gold(instructions, memory = {}, mask = "X" * 36)
  return memory if instructions == []
  val = instructions[0].split(" = ")[1]
  case instructions[0]
  when /mask/
    run_gold(instructions[1..], memory, val)
  when /mem/
    get_address(instructions[0].split(" = ")[0][/\d+/].to_i.to_s(2), mask).each do |addr|
      memory[addr] = val.to_i
    end
    run_gold(instructions[1..], memory, mask)
  end
end

puts sum_memory(run_silver(read_input))
puts run_gold(read_input).values.sum
