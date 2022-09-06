# frozen_string_literal: true

module InferModel
  class Task
    FROMS = { csv: ::InferModel::From::CSV }.freeze
    TOS = { migration: ::InferModel::To::Migration }.freeze

    attr_reader :from_object, :from_args, :from_opts, :to_object, :to_args, :to_opts

    def from(from_object, *args, **opts)
      @from_object = from_object
      @from_object = FROMS.fetch(from_object) if FROMS.key?(from_object)
      @from_args = args
      @from_opts = opts
      self
    end

    def to(to_object, *args, **opts)
      @to_object = to_object
      @to_object = TOS.fetch(to_object) if TOS.key?(to_object)
      @to_args = args
      @to_opts = opts
      self
    end

    def call
      to_object.call(from_object.call(*from_args, **from_opts), *to_args, **to_opts)
    end

    class << self
      def from(...) = new.from(...)
      def to(...) = new.to(...)
    end
  end
end
