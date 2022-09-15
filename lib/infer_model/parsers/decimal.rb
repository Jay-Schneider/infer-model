# frozen_string_literal: true

module InferModel
  class Parsers::Decimal < Parsers::Parser
    def call
      return if safe_value.empty?

      Float(safe_value)
    rescue ArgumentError
      raise Parsers::Error, "'#{safe_value}' is not a Decimal"
    end
  end
end
