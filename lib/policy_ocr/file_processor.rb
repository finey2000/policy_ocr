require_relative 'lines_reader'
require 'fileutils'

module PolicyOcr
  # The FileProcessor class is responsible for processing input files
  # to extract policy numbers and exporting them to an output file.
  class FileProcessor
    attr_accessor :policy_numbers, :input_path, :output_path

    def initialize
      @policy_numbers = []
      @input_path = nil
      @output_path = nil
    end

    # Processes the input file to extract policy numbers and exports them to the output file.
    #
    # @param input_file [String] the path to the input file
    # @param output_file [String] the path to the output file
    def self.perform(input_file, output_file)
      processor = new
      processor.import(input_file)
      processor.export(output_file)
    end

    # Parses the input file and extracts the policy numbers.
    #
    # @param path [String] the path to the input file
    def import(path)
      @input_path = path

      lines = File.readlines(input_path, chomp: true)

      (0...lines.size).step(4) do |i|
        @policy_numbers << LinesReader.parse(lines[i, 3])
      end
    end

    # Writes policy numbers to a text file.
    #
    # @param path [String] the path to the output file
    def export(path)
      @output_path = path
      results = policy_numbers.map(&:to_str)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(output_path, results.join("\n"), mode: 'a')
    end
  end
end
