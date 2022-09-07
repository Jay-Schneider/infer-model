# frozen_string_literal: true

module InferModel
  class Parsers::Integer
    extend Callable
    extend Dry::Initializer

    param :value
    option :allow_blank, default: -> { true }
    option :base, default: -> { 10 }

    def call
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      return if value.nil? || value.empty?

      Integer(value, base)
    rescue ArgumentError
      raise Parsers::Error, "'#{value}' is not an Integer"
    end
  end
end
