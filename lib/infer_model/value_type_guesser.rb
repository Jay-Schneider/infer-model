# frozen_string_literal: true

require "date"
require "json"
require "time"
require_relative "./callable"

module InferModel
  class ValueTypeGuesser
    extend Callable
    extend Dry::Initializer

    param :input
    option :available_types, default: -> { RESULT_TYPES }
    option :multi, default: -> { false }

    INTEGER_RESULT = :integer # bigint included
    DECIMAL_RESULT = :decimal # float included
    DATETIME_RESULT = :datetime # date included
    TIME_RESULT = :time
    BOOLEAN_RESULT = :boolean
    JSON_RESULT = :json
    UUID_RESULT = :uuid
    STRING_RESULT = :string # text included
    RESULT_TYPES = [ # ordered by specifity (string should come last etc)
      INTEGER_RESULT,
      DECIMAL_RESULT,
      BOOLEAN_RESULT,
      TIME_RESULT,
      DATETIME_RESULT,
      JSON_RESULT,
      UUID_RESULT,
      STRING_RESULT,
    ].freeze

    def call
      if multi
        ordered_available_known_types.filter { |type| may_be?(type) }
      else
        inferred_type
      end
    end

    private

    def ordered_available_known_types
      RESULT_TYPES & available_types
    end

    def inferred_type
      @inferred_type ||= ordered_available_known_types.each do |type|
        return type if may_be?(type)
      end
    end

    def may_be?(type) = send("may_be_#{type}?")

    def may_be_integer?
      Integer(input, 10)
    rescue ArgumentError
      false
    end

    def may_be_hex?
      Integer(input, 16)
    rescue ArgumentError
      false
    end

    def may_be_decimal?
      Float(input)
    rescue ArgumentError
      false
    end

    def may_be_boolean?
      may_be_true? || may_be_false?
    end

    def may_be_true?
      input.casecmp("true") * input.casecmp("t") * input.casecmp("x") == 0
    end

    def may_be_false?
      input.casecmp("false") * input.casecmp("f") == 0
    end

    ACCEPTABLE_TIME_FORMATS = %w[%T %R].freeze
    def may_be_time?
      ACCEPTABLE_TIME_FORMATS.any? do |format|
        Time.strptime(input, format)
      rescue ArgumentError
        false
      end
    end

    ACCEPTABLE_DATETIME_FORMATS = [
      "%Y-%m-%d", "%Y-%m-%dT",
      "%d.%m.%Y", "%d.%m.%Y %H:%M",
      "%d.%m.%Y %T", "%d.%m.%Y %T%z", "%d.%m.%Y %T%Z",
      "%Y-%m-%dT%T%z", "%Y-%m-%dT%T%Z",
    ].freeze

    def may_be_datetime?
      ACCEPTABLE_DATETIME_FORMATS.any? do |format|
        DateTime.strptime(input, format)
      rescue ArgumentError
        false
      end
    end

    def may_be_json?
      JSON.parse(input)
    rescue JSON::ParserError
      false
    end

    UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i

    def may_be_uuid?
      UUID_REGEX.match?(input)
    end

    def may_be_string? = true
  end
end
