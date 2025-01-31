module PolicyOcr
  class PolicyOcrError < StandardError; end
  class InvalidPolicyNumberError < PolicyOcrError; end
  class FileProcessingError < PolicyOcrError; end
end
