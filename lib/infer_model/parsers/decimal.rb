# frozen_string_literal: true

module InferModel
  class Parsers::Decimal
    extend Callable
    extend Dry::Initializer

    param :value
    option :allow_blank, default: -> { true }

    def call
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      return if value.nil? || value.empty?

      Float(value)
    rescue ArgumentError
      raise Parsers::Error, "'#{value}' is not a Decimal"
    end
  end
end
