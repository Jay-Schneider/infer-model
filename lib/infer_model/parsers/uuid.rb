# frozen_string_literal: true

module InferModel
  class Parsers::UUID
    extend Callable
    extend Dry::Initializer

    UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i

    param :value
    option :allow_blank, default: -> { true }

    def call
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      return if value.nil? || value.empty?
      return value if UUID_REGEX.match?(value)

      raise Parsers::Error, "'#{value}' is not a UUID"
    end
  end
end
