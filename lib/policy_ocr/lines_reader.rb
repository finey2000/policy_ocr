require_relative 'policy_number'
require_relative 'checksum_validator'

module PolicyOcr
  class LinesReader
    # This map serves as a lookup table to map the visual representation of each digit
    DIGIT_MAP = {
      " _ | ||_|" => "0",
      "     |  |" => "1",
      " _  _||_ " => "2",
      " _  _| _|" => "3",
      "   |_|  |" => "4",
      " _ |_  _|" => "5",
      " _ |_ |_|" => "6",
      " _   |  |" => "7",
      " _ |_||_|" => "8",
      " _ |_| _|" => "9"
    }.freeze

    class << self
      def parse(lines)
        return nil if lines.nil? || lines.size < 3
    
        number_str = (0...27).step(3).map do |index|
          segment = extract_segment(lines, index)
          DIGIT_MAP.fetch(segment, "?")
        end.join
  
        PolicyNumber.new(number_str)
      end
    
      private
    
      # Extracts a 3x3 segment for a single digit
      def extract_segment(lines, index)
        lines.map { |line| line[index, 3] }.join
      end
    end
  end
end
