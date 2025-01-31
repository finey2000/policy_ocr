require 'logger'

module PolicyOcr
  class LogHandler
    LOGGER = Logger.new('log/development.log')

    def self.error(error)
      LOGGER.error("#{error.class}: #{error.message}")
      LOGGER.error(error.backtrace.join("\n"))
    end

    def self.warning(message)
      LOGGER.warn(message)
    end

    def self.info(message)
      LOGGER.info(message)
    end
  end
end
