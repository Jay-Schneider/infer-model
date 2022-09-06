# frozen_string_literal: true

require "date"
require "json"
require "time"

module InferModel
  class ValueTypeGuesser
    extend Callable
    extend Dry::Initializer

    param :input
    option :available_types, default: -> { RESULT_TYPES }
    option :multi, default: -> { false }
    option :allow_blank, default: -> { true }

    INTEGER_RESULT = :integer # bigint included
    DECIMAL_RESULT = :decimal # float included
    DATETIME_RESULT = :datetime # date included
    TIME_RESULT = :time
    BOOLEAN_RESULT = :boolean
    JSON_RESULT = :json
    UUID_RESULT = :uuid
    STRING_RESULT = :string # text included
    RESULT_TYPES = [ # ordered by specifity (string should come last, integer before decimal etc.)
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
      raise Error, "Provide strings only for guessing the type" unless input.is_a?(String) || input.nil?
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
      nil
    end

    def may_be?(type)
      return allow_blank if input.nil? || input.empty?

      send("may_be_#{type}?")
    end

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

    TRUTHY_VALUES_LOWERCASE = %w[true t x y j + *].freeze
    def may_be_true?
      TRUTHY_VALUES_LOWERCASE.any? { |truth| input.casecmp(truth).zero? }
    end

    FALSEY_VALUES_LOWERCASE = %w[false f n].freeze
    def may_be_false?
      input.empty? || FALSEY_VALUES_LOWERCASE.any? { |lie| input.casecmp(lie).zero? }
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
      "%Y-%m-%dT%T%z", "%Y-%m-%dT%T%Z", "%Y-%m-%dT%TZ",
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
