# frozen_string_literal: true

module InferModel
  class CommonTypeGuesser
    extend Callable
    extend Dry::Initializer

    param :inputs
    option :available_types, default: -> { ValueTypeGuesser::RESULT_TYPES }
    option :multi, default: -> { false }
    option :allow_blank, default: -> { true }
    option :detect_uniqueness, default: -> { true }
    option :detect_non_null, default: -> { true }

    def call
      inputs.each do |input|
        @available_types = ValueTypeGuesser.call(input, allow_blank:, available_types:, multi: true)
      end
      possible_detected_types = multi ? available_types : available_types.first

      @parsed_inputs = inputs.map { Parsers::BY_TYPE.fetch(available_types.first).call(_1) }

      CommonType.new(
        possible_detected_types,
        unique_constraint_possible:,
        non_null_constraint_possible:,
      )
    end

    private

    def unique_constraint_possible
      return unless detect_uniqueness

      @parsed_inputs.size == @parsed_inputs.uniq.size
    end

    def non_null_constraint_possible
      return unless detect_non_null

      @parsed_inputs.none?(&:nil?)
    end
  end
end
