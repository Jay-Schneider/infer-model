# frozen_string_literal: true

module InferModel
  module Callable
    def call(...)
      new(...).call
    end

    alias call! call
  end
end
