# frozen_string_literal: true

module InferModel
  class Parsers::Boolean
    extend Callable
    extend Dry::Initializer

    param :value

    TRUTHY_VALUES_LOWERCASE = %w[true t x y j + *].freeze
    FALSEY_VALUES_LOWERCASE = %w[false f n].freeze

    def call
      return false if value.empty?
      return false if FALSEY_VALUES_LOWERCASE.any? { |lie| value.casecmp(lie).zero? }
      return true if TRUTHY_VALUES_LOWERCASE.any? { |truth| value.casecmp(truth).zero? }

      raise Parsers::Error, "'#{value}' is not a Boolean"
    end
  end
end
