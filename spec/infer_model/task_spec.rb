# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::Task do
  describe "from/to chaining" do
    context "when from comes before to" do
      subject(:result) { described_class.from(:csv, "foo/bar", csv_options: { col_sep: ";", encoding: "csp1252" }).to(:migration, rails_version: "6.0", table_name: "bar_baz") }

      it "creates the desired attributes" do
        is_expected.to have_attributes(
          class: described_class,
          from_object: InferModel::From::CSV,
          from_args: %w[foo/bar],
          from_opts: {
            csv_options: { col_sep: ";", encoding: "csp1252" },
          },
          to_object: InferModel::To::Migration,
          to_args: [],
          to_opts: { rails_version: "6.0", table_name: "bar_baz" },
        )
      end
    end

    context "when from comes after to" do
      subject(:result) { described_class.to(:migration, rails_version: "6.0", table_name: "bar_baz").from(:csv, "foo/bar", csv_options: { col_sep: ";", encoding: "csp1252" }) }

      it "creates the desired attributes" do
        is_expected.to have_attributes(
          class: described_class,
          from_object: InferModel::From::CSV,
          from_args: %w[foo/bar],
          from_opts: {
            csv_options: { col_sep: ";", encoding: "csp1252" },
          },
          to_object: InferModel::To::Migration,
          to_args: [],
          to_opts: { rails_version: "6.0", table_name: "bar_baz" },
        )
      end
    end
  end
end
