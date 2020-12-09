def read_input
  File.new("./input.txt").read.split("\n")
end

def run(data, addr = 0, acc = 0, used_adress = [])
  return nil if used_adress.include?(addr)
  return "end file with acc = #{acc}" if addr >= data.length
  case data[addr][0]
  when "acc"
    run(data, addr + 1, acc + data[addr][1], used_adress << addr)
  when "jmp"
    run(data, addr + data[addr][1], acc, used_adress << addr)
  when "nop"
    run(data, addr + 1, acc, used_adress << addr)
  end
end

def parse_data(input)
  [input.split(" ")[0], input[/\d+/].to_i * (input[/-/] ? -1 : 1)]
end

def try_all
  data = read_input.map { |i| parse_data(i) }
  data.length.times do |i|
    dup_data = data.map { |i| i.dup }
    case data[i][0]
    when "jmp"
      dup_data[i][0] = "nop"
    when "nop"
      dup_data[i][0] = "jmp"
    end
    result = run(dup_data)
    return result if result != nil
  end
end

puts try_all
