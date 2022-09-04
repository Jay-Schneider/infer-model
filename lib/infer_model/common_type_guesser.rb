# frozen_string_literal: true

module InferModel
  class CommonTypeGuesser
    extend Callable
    extend Dry::Initializer

    param :inputs
    option :available_types, default: -> { ValueTypeGuesser::RESULT_TYPES }
    option :multi, default: -> { false }
    option :allow_blank, default: -> { true }

    def call
      inputs.each do |input|
        @available_types = ValueTypeGuesser.call(input, allow_blank:, available_types:, multi: true)
      end
      multi ? available_types : available_types.first
    end
  end
end
