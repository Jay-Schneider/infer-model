# frozen_string_literal: true

require "date"

module InferModel
  class Parsers::DateTime
    extend Callable
    extend Dry::Initializer

    ACCEPTABLE_DATETIME_FORMATS = [
      "%Y-%m-%dT%T%z",
      "%Y-%m-%dT%T%Z",
      "%Y-%m-%dT%TZ",
      "%d.%m.%Y %T%z",
      "%d.%m.%Y %T%Z",
      "%d.%m.%Y %T",
      "%d.%m.%Y %H:%M",
      "%Y-%m-%dT",
      "%Y-%m-%d",
      "%d.%m.%Y",
    ].freeze

    param :value

    def call
      ACCEPTABLE_DATETIME_FORMATS.each do |format|
        return DateTime.strptime(value, format)
      rescue Date::Error
        next
      end

      raise Parsers::Error, "'#{value}' is not a DateTime"
    end
  end
end
