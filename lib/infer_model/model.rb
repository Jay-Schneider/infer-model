# frozen_string_literal: true

module InferModel
  class Model
    extend Dry::Initializer

    option :source_name
    option :attributes
  end
end
