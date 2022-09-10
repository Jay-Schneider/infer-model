# frozen_string_literal: true

module InferModel
  class Parsers::Integer < Parsers::Parser
    option :base, default: -> { 10 }

    def call
      return if safe_value.empty?

      Integer(safe_value, base)
    rescue ArgumentError
      raise Parsers::Error, "'#{safe_value}' is not an Integer"
    end
  end
end
