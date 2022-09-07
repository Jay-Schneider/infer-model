# frozen_string_literal: true

require "json"

module InferModel
  class Parsers::JSON
    extend Callable
    extend Dry::Initializer

    param :value
    option :allow_blank, default: -> { true }

    def call
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      return if value.nil? || value.empty?

      JSON.parse(value)
    rescue JSON::ParserError
      raise Parsers::Error, "'#{value}' is not a JSON"
    end
  end
end
