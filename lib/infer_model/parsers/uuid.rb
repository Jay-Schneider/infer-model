# frozen_string_literal: true

module InferModel
  class Parsers::UUID
    extend Callable
    extend Dry::Initializer

    UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i

    param :value

    def call
      return value if UUID_REGEX.match?(value)

      raise Parsers::Error, "'#{value}' is not a UUID"
    end
  end
end
