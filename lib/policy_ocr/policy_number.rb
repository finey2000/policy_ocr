require_relative 'checksum_validator'

module PolicyOcr
  # The PolicyNumber class represents a policy number and provides methods
  # to validate and format the policy number.
  class PolicyNumber
    attr_accessor :number, :valid, :illegible_count

    alias valid? valid

    # Initializes a new PolicyNumber instance.
    #
    # @param number [String] the policy number
    # @raise [RuntimeError] if the number is not a valid string
    def initialize(number)
      raise 'Number must be a valid string' if number.class != String || number.empty?

      @number = number
      @illegible_count = number.count('?')
      validate
    end

    # Returns the policy number as a string, with a suffix indicating its status.
    #
    # @return [String] the policy number with a status suffix
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

    # Validates the policy number using the ChecksumValidator.
    def validate
      @valid = illegible_count.zero? && ChecksumValidator.valid?(number)
    end
  end
end
