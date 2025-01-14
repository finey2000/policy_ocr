module PolicyOcr
  # The ChecksumValidator class is responsible for validating policy numbers
  # using a checksum algorithm.
  class ChecksumValidator
    # Validates the given policy number using a checksum algorithm.
    #
    # @param policy_number [String] the policy number to validate
    # @return [Boolean] true if the policy number is valid, false otherwise
    def self.valid?(policy_number)
      return false if policy_number.class != String || policy_number.empty?

      digits = policy_number.chars.map(&:to_i)
      checksum = digits.each_with_index.sum { |digit, index| digit * (9 - index) }
      (checksum % 11).zero?
    end
  end
end
