module PolicyOcr
  # Validates the checksum for a given policy number
  class ChecksumValidator
    def self.valid?(policy_number)
      return false if policy_number.class != String || policy_number.empty?

      digits = policy_number.chars.map(&:to_i)
      checksum = digits.each_with_index.sum { |digit, index| digit * (9 - index) }
      (checksum % 11).zero?
    end
  end
end
