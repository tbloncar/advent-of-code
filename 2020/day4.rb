PASSPORTS = File.read('passports.txt').split("\n\n").freeze

def provided_fields_with_values(passport)
  passport.split(/\s/).map { |v| v.split(':') }.to_h
end

def provided_fields(passport)
  provided_fields_with_values(passport).keys
end

REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid).freeze

def part1_valid?(passport)
  REQUIRED_FIELDS - provided_fields(passport) == []
end

def part2_valid?(passport)
  return false unless part1_valid?(passport)

  provided_fields_with_values(passport).all? do |k,v|
    case k
    when 'byr' then v.size == 4 && (1920..2002).include?(v.to_i)
    when 'iyr' then v.size == 4 && (2010..2020).include?(v.to_i)
    when 'eyr' then v.size == 4 && (2020..2030).include?(v.to_i)
    when 'hgt'
      match = v.match(/^(\d+)(in|cm)$/)
      match && ((match[2] == 'cm' && (150..193).include?(match[1].to_i)) || (match[2] == 'in' && (59..76).include?(match[1].to_i)))
    when 'hcl' then v.match?(/^#[0-9a-f]{6}$/)
    when 'ecl' then %w(amb blu brn gry grn hzl oth).include?(v)
    when 'pid' then v.match?(/^[0-9]{9}$/)
    else
      true
    end
  end
end

def solution_part_1
  PASSPORTS.count do |passport|
    part1_valid?(passport)
  end
end

def solution_part_2
  PASSPORTS.count do |passport|
    part2_valid?(passport)
  end
end


if ARGV[0] == "test"
  # Test provided_fields
  puts provided_fields("eyr:2027
hcl:#602927
hgt:186cm byr:1939 iyr:2019 pid:552194973 ecl:hzl
") == %w(eyr hcl hgt byr iyr pid ecl)
  puts provided_fields("eyr:2020") == %w(eyr)

  # Test part1_valid?
  puts part1_valid?("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm") == true
  puts part1_valid?("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929") == false
  puts part1_valid?("hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm") == true
  puts part1_valid?("hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in") == false

  # Test part2_valid?
  # Invalid
  puts part2_valid?("eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926") == false
  puts part2_valid?("iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946") == false
  puts part2_valid?("hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277") == false
  puts part2_valid?("hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007") == false
  # Valid
  puts part2_valid?("pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f") == true
  puts part2_valid?("eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm") == true
  puts part2_valid?("hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022") == true
  puts part2_valid?("iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719") == true
else
  puts solution_part_1
  puts solution_part_2
end
