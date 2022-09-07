# frozen_string_literal: true

module InferModel
  class Parsers::Decimal
    extend Callable
    extend Dry::Initializer

    param :value

    def call
      Float(value)
    rescue ArgumentError
      raise Parsers::Error, "'#{value}' is not a Decimal"
    end
  end
end
