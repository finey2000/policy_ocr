DIGITS = [
  " _ | ||_|", # 0
  "     |  |", # 1
  " _  _||_ ", # 2
  " _  _| _|", # 3
  "   |_|  |", # 4
  " _ |_  _|", # 5
  " _ |_ |_|", # 6
  " _   |  |", # 7
  " _ |_||_|", # 8
  " _ |_| _|"  # 9
]

def generate_random_entry
  entry = Array.new(3) { '' }
  9.times do
    digit = DIGITS.sample
    entry[0] << digit[0, 3]
    entry[1] << digit[3, 3]
    entry[2] << digit[6, 3]
  end
  entry.join("\n")
end

File.open('spec/fixtures/large_sample.txt', 'w') do |file|
  500.times do
    file.puts generate_random_entry
    file.puts "\n"
  end
end
