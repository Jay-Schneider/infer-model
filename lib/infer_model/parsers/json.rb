# frozen_string_literal: true

require "json"

module InferModel
  class Parsers::JSON < Parsers::Parser
    def call
      return if safe_value.empty?

      ::JSON.parse(safe_value)
    rescue ::JSON::ParserError
      raise Parsers::Error, "'#{safe_value}' is not a JSON"
    end
  end
end
