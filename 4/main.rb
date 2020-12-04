KEYS = {
  "byr" => ->(d) { d.to_i.between?(1920, 2002) },
  "iyr" => ->(n) { n.to_i.between?(2010, 2020) },
  "eyr" => ->(n) { n.to_i.between?(2020, 2030) },
  "hgt" => ->(n) {
    if n[/\D+/] == "in"
      n[/\d+/].to_i.between?(59, 76)
    elsif n[/\D+/] == "cm"
      n[/\d+/].to_i.between?(150, 193)
    else
      false
    end
  },
  "hcl" => ->(n) { n[/#\w+/].length == 7 },
  "ecl" => ->(n) { ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include?(n) },
  "pid" => ->(n) { n[/\d+/].length == 9 },
#   "cid",
}

def read_input
  File.new("./input.txt")
      .read
      .split("\n")
end

def selperate_passwords(input_data, passports = [""])
  return passports if input_data == []
  return selperate_passwords(
           input_data[1..],
           passports << ""
         ) if input_data[0] == ""
  passports[-1] << ":#{input_data[0]}".split(" ").join(":")
  selperate_passwords(
    input_data[1..],
    passports
  )
end

def to_json(passport)
  json = {}
  vals = passport.split(":")
  vals.length.times do |i|
    json[vals[i]] = vals[i + 1] unless i % 2 == 0
  end
  json
end

def is_valid_pass?(passport)
  begin
    KEYS.keys.each do |k|
      if KEYS[k].call(passport[k]) == false
        puts k
        return false
      end
    end
    return true
  rescue => exception
    false
  end
end

puts selperate_passwords(read_input)
       .map { |p| to_json(p) }
       .filter { |p| is_valid_pass?(p) }
       .length
