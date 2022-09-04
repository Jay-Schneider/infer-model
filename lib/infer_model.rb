# frozen_string_literal: true

require "dotenv/load"
require "dry-initializer"
require "pry"
require_relative "infer_model/version"
require_relative "infer_model/common_type_guesser"

module InferModel
  class Error < StandardError; end
  # Your code goes here...
end
