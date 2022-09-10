# frozen_string_literal: true

require "time"

module InferModel
  class Parsers::Time
    extend Callable
    extend Dry::Initializer

    ACCEPTABLE_TIME_FORMATS = %w[%T %R].freeze

    param :value
    option :allow_blank, default: -> { true }

    def call
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      return if value.nil? || value.empty?

      ACCEPTABLE_TIME_FORMATS.each do |format|
        return ::Time.strptime(value, format)
      rescue ArgumentError
        next
      end

      raise Parsers::Error, "'#{value}' is not a Time"
    end
  end
end
