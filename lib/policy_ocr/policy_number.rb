require_relative 'checksum_validator'
require_relative 'digits'
require_relative 'log_handler'
require_relative 'errors'

module PolicyOcr
  # The PolicyNumber class represents a policy number and provides methods
  # to validate and format the policy number.
  class PolicyNumber
    attr_accessor :number, :valid, :illegible_count, :encoded_form, :corrections, :correct_number

    alias valid? valid

    CORRECTIONS_MAP = {
      ' ' => ['|', '_'],
      '|' => [' ', '_'],
      '_' => [' ', '|']
    }.freeze

    # Class-level variable to store the precomputed map
    @precomputed_corrections_map = nil

    # Initializes a new PolicyNumber instance.
    #
    # @param number [String] the policy number
    # @raise [RuntimeError] if the number is not a valid string
    def initialize(number, encoded_form:, run_checks: true)
      raise InvalidPolicyNumberError, 'Number must be a valid string' if number.class != String || number.empty?

      @number = number
      @encoded_form = encoded_form
      @corrections = []
      @illegible_count = number.count('?')
      validate_and_correct if run_checks
    end

    # Returns the policy number as a string, with a suffix indicating its status.
    #
    # @return [String] the policy number with a status suffix
    def to_str
      validated_number + str_prefix
    end

    def str_prefix
      if valid_number?
        ''
      elsif corrections.size > 1
        ' AMB'
      elsif illegible_count.positive?
        ' ILL'
      else
        ' ERR'
      end
    end

    def valid_number?
      valid || !correct_number.nil?
    end

    def validated_number
      correct_number || number
    end


    # Validates and corrects the policy number using the ChecksumValidator.
    def validate_and_correct
      @valid = illegible_count.zero? && ChecksumValidator.valid?(number)

      return if valid || encoded_form.nil?

      @corrections = guess_corrections.select do |correction|
        correction.count('?').zero? &&  ChecksumValidator.valid?(correction)
      end

      @correct_number = corrections.first if corrections.size == 1
      corrections
    end

    # Precomputes corrections map if not already initialized
    def self.precomputed_corrections_map
      @precomputed_corrections_map ||= begin
      LogHandler.info('precomputing corrections')
        precomputed_map = {}
        Digits::MAP.each_key do |digit_code|
          CORRECTIONS_MAP.each do |char, replacements|
            digit_code.chars.each_with_index do |c, i|
              next unless c == char

              replacements.each do |replacement|
                corrected_code = digit_code.dup
                corrected_code[i] = replacement
                precomputed_map[digit_code] ||= []
                precomputed_map[digit_code] << corrected_code if Digits::MAP[corrected_code]
              end
            end
          end
        end
        precomputed_map
      end
    end

    private

    def guess_corrections
      possible_corrections = []

      encoded_form.each_with_index do |digit_code, index|
        next unless digit_code.size == 9

        corrections = self.class.precomputed_corrections_map[digit_code] || generate_corrections(digit_code)
        corrections.each do |corrected_code|
          corrected_digit = Digits::MAP[corrected_code]
          next unless corrected_digit

          corrected_number = number.dup
          corrected_number[index] = corrected_digit
          possible_corrections << corrected_number
        end
      end

      possible_corrections
    end

    def generate_corrections(digit_code)
      corrections = []

      digit_code.chars.each_with_index do |char, char_index|
        next unless CORRECTIONS_MAP.key?(char)

        CORRECTIONS_MAP[char].each do |replacement|
          corrected_digit_code = digit_code.dup
          corrected_digit_code[char_index] = replacement
          corrections << corrected_digit_code
        end
      end

      corrections
    end
  end
end
