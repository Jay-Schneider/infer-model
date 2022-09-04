# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::From::CSV do
  describe "#call" do
    subject(:result) { described_class.call("spec/fixtures/csv/happy_path.csv") }

    it "detects the types from the happy path fixture" do
      expect(result).to eq({
        integer_col: :integer,
        decimal_col: :decimal,
        datetime_col: :datetime,
        time_col: :time,
        boolean_col: :boolean,
        json_col: :json,
        uuid_col: :uuid,
        string_col: :string,
      })
    end

    context "when available_types are restricted" do
      let(:available_types) { %i[decimal datetime boolean string] }
      subject(:result) { described_class.call("spec/fixtures/csv/happy_path.csv", available_types:) }

      it "detects the types from the happy path fixture" do
        expect(result).to eq({
          integer_col: :decimal,
          decimal_col: :decimal,
          datetime_col: :datetime,
          time_col: :string,
          boolean_col: :boolean,
          json_col: :string,
          uuid_col: :string,
          string_col: :string,
        })
      end
    end
  end
end
