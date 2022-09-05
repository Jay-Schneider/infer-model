# frozen_string_literal: true

require "dotenv/load"
require "dry-initializer"
require "pry"
require_relative "infer_model/callable"
require_relative "infer_model/common_type_guesser"
require_relative "infer_model/common_type"
require_relative "infer_model/from"
require_relative "infer_model/from/csv"
require_relative "infer_model/to"
require_relative "infer_model/to/migration"
require_relative "infer_model/value_type_guesser"
require_relative "infer_model/version"

module InferModel
  class Error < StandardError; end
  # Your code goes here...
end
