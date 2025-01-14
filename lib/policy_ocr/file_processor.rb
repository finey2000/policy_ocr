require_relative 'lines_reader'
require 'fileutils';

module PolicyOcr
  class FileProcessor
    attr_accessor :policy_numbers, :input_path, :output_path

    def initialize
      @policy_numbers = []
      @input_path = nil
      @output_path = nil
    end

    # Parses the input file and extracts the policy numbers
    def import(path)
      @input_path = path

      lines = File.readlines(input_path).map(&:chomp)
  
      (0...lines.size).step(4) do |i|
        @policy_numbers << LinesReader.parse(lines[i, 3])
      end
    end

    # Writes policy numbers to a text file
    def export(path)
      @output_path = path
      results = policy_numbers.map { |policy_number| policy_number.to_str }
      FileUtils.mkdir_p(File.dirname(path));
      File.write(output_path, results.join("\n"), mode: 'a')
    end
  end
end
