# frozen_string_literal: true

# libraries
require "dotenv/load"
require "dry-initializer"
require "pry"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("csv" => "CSV", "json" => "JSON", "uuid" => "UUID")
loader.setup

module InferModel
  class Error < StandardError; end

  class << self
    def from(...) = Task.from(...)
    def to(...) = Task.to(...)
  end
end
