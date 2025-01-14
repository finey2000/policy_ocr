require 'data'
require_relative 'checksum_validator'

module PolicyOcr
  class PolicyNumber
    attr_accessor :number, :valid, :illegible_count

    alias valid? valid

    # @param number [String]
    def initialize(number)
      raise 'Number must be a valid string' if number.class != String  || number.empty?

      @number = number
      @illegible_count = number.count('?')
      validate
    end

    # @return [String]
    def to_str
      if illegible_count.positive?
        "#{number} ILL"
      elsif valid
        number
      else
        "#{number} ERR"
      end
    end

    private

    def validate
      @valid = illegible_count.zero? && ChecksumValidator.valid?(number)
    end
  end
end
