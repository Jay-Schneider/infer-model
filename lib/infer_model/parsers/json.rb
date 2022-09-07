# frozen_string_literal: true

require "json"

module InferModel
  class Parsers::JSON
    extend Callable
    extend Dry::Initializer

    param :value

    def call
      JSON.parse(value)
    rescue JSON::ParserError
      raise Parsers::Error, "'#{value}' is not a JSON"
    end
  end
end
