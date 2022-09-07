# frozen_string_literal: true

module InferModel::Callable
  def call(...) = new(...).call
  alias call! call
end
