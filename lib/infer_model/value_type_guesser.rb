# frozen_string_literal: true

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
        ordered_available_known_types.find { |type| may_be?(type) }
      end
    end

    private

    def ordered_available_known_types
      RESULT_TYPES & available_types
    end

    def may_be?(type)
      type = type.to_s.downcase.to_sym
      raise ArgumentError, "unknown type '#{type}'" unless InferModel::Parsers::BY_TYPE.key?(type)
      return allow_blank if input.nil? || input.empty?

      InferModel::Parsers::BY_TYPE.fetch(type).call(input) || true # false is allowed for boolean
    rescue Parsers::Error
      false
    end
  end
end
