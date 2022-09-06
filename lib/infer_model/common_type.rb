# frozen_string_literal: true

module InferModel
  class CommonType
    extend Dry::Initializer

    param :possible_detected_types
    option :unique_constraint_possible, default: -> { false }
    option :non_null_constraint_possible, default: -> { false }

    def detected_type
      possible_detected_types.respond_to?(:first) ? possible_detected_types.first : possible_detected_types
    end
  end
end
