# frozen_string_literal: true

module InferModel
  class Parsers::Boolean < Parsers::Parser
    TRUTHY_VALUES_LOWERCASE = %w[true t x y j + * 1].freeze
    FALSEY_VALUES_LOWERCASE = %w[false f n - 0].freeze

    def call
      return false if safe_value.empty?
      return false if FALSEY_VALUES_LOWERCASE.any? { |lie| lie.casecmp(safe_value)&.zero? }
      return true if TRUTHY_VALUES_LOWERCASE.any? { |truth| truth.casecmp(safe_value)&.zero? }

      raise Parsers::Error, "'#{safe_value}' is not a Boolean"
    end
  end
end
