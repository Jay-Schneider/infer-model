# frozen_string_literal: true

module InferModel
  class Parsers::Parser
    extend Callable
    extend Dry::Initializer

    param :value
    option :allow_blank, default: -> { true }

    private

    def safe_value
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      value || ""
    end
  end
end
