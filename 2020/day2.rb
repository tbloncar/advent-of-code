passwords_with_policy = File.read('passwords.txt').split("\n")

part1_valid_count = 0
part2_valid_count = 0

def part1_valid?(password, char, min, max)
  count = password.chars.select { |c| c == char }.count
  (min..max).include?(count)
end

def part2_valid?(password, char, position1, position2)
  [password[position1 - 1], password[position2 - 1]].count { |c| c == char } == 1
end

passwords_with_policy.each do |password_with_policy|
  # Ex: 15-16 f: ffffffffffffffhf
  # range, char, password = password_with_policy.split(' ')

  match = password_with_policy.match(/(\d+)-(\d+) ([a-z]): (.*)/)
  _, a, b, char, password = match.to_a

  a = a.to_i
  b = b.to_i

  part1_valid_count += 1 if part1_valid?(password, char, a, b)
  part2_valid_count += 1 if part2_valid?(password, char, a, b)
end


if ARGV[0] == "test"
  puts part2_valid?("abcde", "a", 1, 3) == true
  puts part2_valid?("cdefg", "b", 1, 3) == false
  puts part2_valid?("ccccccccc", "c", 2, 9) == false
else
  puts "#{part1_valid_count} out of #{passwords_with_policy.count} passwords are valid"
  puts "#{part2_valid_count} out of #{passwords_with_policy.count} passwords are valid"
end
