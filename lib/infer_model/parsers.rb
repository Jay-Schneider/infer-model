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
      string: ->(*args, **_opts) { args[0] },
    }.freeze
  end
end
