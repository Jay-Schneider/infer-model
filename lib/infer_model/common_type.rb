# frozen_string_literal: true

module InferModel
  class CommonType
    extend Dry::Initializer

    param :possible_detected_types
    option :unique_constraint_possible, optional: true
    option :non_null_constraint_possible, optional: true

    def ==(other)
      return possible_detected_types == other if other.is_a?(Symbol)
      return possible_detected_types == other if other.respond_to?(:all?) && other.all? { |o| o.is_a?(Symbol) }

      super(other)
    end

    def inspect
      "<#{self.class.name}: #{[
        possible_detected_types.to_s,
        unique_constraint_possible ? "only unique values" : nil,
        non_null_constraint_possible ? "no empty values" : nil,
      ].compact.join(", ")}>"
    end
  end
end
