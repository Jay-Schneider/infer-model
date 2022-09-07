# frozen_string_literal: true

# libraries
require "dotenv/load"
require "dry-initializer"
require "pry"

# patterns
require "infer_model/callable"

# generics
require "infer_model/parsers"
require "infer_model/parsers/boolean"
require "infer_model/parsers/datetime"
require "infer_model/parsers/decimal"
require "infer_model/parsers/integer"
require "infer_model/parsers/json"
require "infer_model/parsers/time"
require "infer_model/parsers/uuid"
require "infer_model/common_type"
require "infer_model/value_type_guesser"
require "infer_model/common_type_guesser"

# adapters
require "infer_model/from"
require "infer_model/from/csv"
require "infer_model/to"
require "infer_model/to/migration"
require "infer_model/to/text"

# main classes
require "infer_model/model"
require "infer_model/task"
require "infer_model/version"

module InferModel
  class Error < StandardError; end

  class << self
    def from(...) = Task.from(...)
    def to(...) = Task.to(...)
  end
end
