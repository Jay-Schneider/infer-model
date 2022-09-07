# frozen_string_literal: true

module InferModel
  class Parsers::Integer
    extend Callable
    extend Dry::Initializer

    param :value
    option :base, default: -> { 10 }

    def call
      Integer(value, base)
    rescue ArgumentError
      raise Parsers::Error, "'#{value}' is not an Integer"
    end
  end
end
