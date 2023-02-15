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
    option :allow_blank, default: -> { true }
    option :time_zone_offset, default: -> { "+00:00" }

    def call
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      return if value.nil? || value.empty?

      datetime_without_zone = parsed_datetime.iso8601[..-7]
      datetime_with_custom_zone = datetime_without_zone + time_zone_offset
      DateTime.parse(datetime_with_custom_zone)
    end

    private

    def parsed_datetime
      ACCEPTABLE_DATETIME_FORMATS.each do |format|
        return DateTime.strptime(value, format)
      rescue Date::Error
        next
      end

      raise Parsers::Error, "'#{value}' is not a DateTime"
    end
  end
end
