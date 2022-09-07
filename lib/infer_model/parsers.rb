# frozen_string_literal: true

module InferModel
  module Parsers
    Error = Class.new(StandardError)

    BY_TYPE = {
      boolean: Boolean,
      datetime: DateTime,
      decimal: Decimal,
      integer: Integer,
      json: JSON,
      time: Time,
      uuid: UUID,
      string: -> { _1 },
    }.freeze
  end
end
