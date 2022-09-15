# frozen_string_literal: true

module InferModel
  class Parsers::UUID < Parsers::Parser
    UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i

    def call
      return if safe_value.empty?
      return safe_value if UUID_REGEX.match?(safe_value)

      raise Parsers::Error, "'#{safe_value}' is not a UUID"
    end
  end
end
