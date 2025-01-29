require_relative 'policy_number'
require_relative 'digits'

module PolicyOcr
  # The LinesReader class is responsible for parsing OCR digit lines
  # and extracting the policy number.
  class LinesReader
    class << self
      # Parses the given lines to extract the policy number.
      #
      # @param lines [Array<String>] the lines representing the OCR digits
      # @return [PolicyNumber, nil] the parsed policy number or nil if the input is invalid
      def parse(lines)
        return nil if lines.nil? || lines.size < 3
    
        segments = []
        number_str = (0...27).step(3).map do |index|
          segment = extract_segment(lines, index)
          segments << segment
          Digits::MAP.fetch(segment, "?")
        end.join
  
        PolicyNumber.new(number_str, encoded_form: segments)
      end
    
      private
    
      # Extracts a 3x3 segment for a single digit from the given lines.
      #
      # @param lines [Array<String>] the lines representing the OCR digits
      # @param index [Integer] the starting index of the segment
      # @return [String] the extracted 3x3 segment as a string
      def extract_segment(lines, index)
        lines.map { |line| line[index, 3] }.join
      end
    end
  end
end
