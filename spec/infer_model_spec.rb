# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel do
  it "has a version number" do
    expect(InferModel::VERSION).not_to be nil
  end

  describe "#from" do
    subject(:result) { described_class.from(:csv, "foo/bar") }

    it "returns a task with the from attributes set" do
      expect(result).to have_attributes(
        class: InferModel::Task,
        from_object: InferModel::From::CSV,
        from_args: %w[foo/bar],
      )
    end
  end

  describe "#to" do
    subject(:result) { described_class.to(:migration, rails_version: "6.0") }

    it "returns a task with the to attributes set" do
      expect(result).to have_attributes(
        class: InferModel::Task,
        to_object: InferModel::To::Migration,
        to_opts: { rails_version: "6.0" },
      )
    end
  end
end
