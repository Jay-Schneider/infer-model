# frozen_string_literal: true

require "time"

module InferModel
  class Parsers::Time < Parsers::Parser
    ACCEPTABLE_TIME_FORMATS = %w[%T %R].freeze

    def call
      return if safe_value.empty?

      ACCEPTABLE_TIME_FORMATS.each do |format|
        return ::Time.strptime(safe_value, format)
      rescue ArgumentError
        next
      end

      raise Parsers::Error, "'#{safe_value}' is not a Time"
    end
  end
end
