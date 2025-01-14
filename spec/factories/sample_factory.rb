require_relative '../../lib/policy_ocr/digits'

def generate_random_entry
  entry = Array.new(3) { '' }
  9.times do
    digit = PolicyOcr::Digits::MAP.keys.sample
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
