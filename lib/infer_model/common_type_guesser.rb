# frozen_string_literal: true

require_relative "./value_type_guesser"

module InferModel
  class CommonTypeGuesser
    extend Callable
    extend Dry::Initializer

    param :inputs
    option :available_types, default: -> { ValueTypeGuesser::RESULT_TYPES }
    option :multi, default: -> { false }

    def call
      inputs.each do |input|
        @available_types = ValueTypeGuesser.new(input, available_types:, multi: true).call
      end
      multi ? available_types : available_types.first
    end
  end
end
