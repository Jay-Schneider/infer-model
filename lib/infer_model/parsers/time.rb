# frozen_string_literal: true

require "time"

module InferModel
  class Parsers::Time
    extend Callable
    extend Dry::Initializer

    ACCEPTABLE_TIME_FORMATS = %w[%T %R].freeze

    param :value

    def call
      ACCEPTABLE_TIME_FORMATS.each do |format|
        return Time.strptime(value, format)
      rescue ArgumentError
        next
      end

      raise Parsers::Error, "'#{value}' is not a Time"
    end
  end
end
