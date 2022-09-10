# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::From::CSV do
  describe "#call" do
    subject(:result) { described_class.call("spec/fixtures/csv/happy_path.csv", csv_options: { quote_char: "\x00" }) }

    it "detects the types from the happy path fixture" do
      expect(result).to have_attributes(
        class: InferModel::Model,
        source_name: "happy_path",
        attributes: {
          integer_col: an_object_having_attributes(detected_type: :integer),
          decimal_col: an_object_having_attributes(detected_type: :decimal),
          datetime_col: an_object_having_attributes(detected_type: :datetime),
          time_col: an_object_having_attributes(detected_type: :time),
          boolean_col: an_object_having_attributes(detected_type: :boolean),
          json_col: an_object_having_attributes(detected_type: :json),
          uuid_col: an_object_having_attributes(detected_type: :uuid),
          string_col: an_object_having_attributes(detected_type: :string),
        },
      )
    end

    context "when available_types are restricted" do
      let(:available_types) { %i[decimal datetime boolean string] }
      subject(:result) { described_class.call("spec/fixtures/csv/happy_path.csv", available_types:, csv_options: { quote_char: "\x00" }) }

      it "detects the types from the happy path fixture" do
        expect(result).to have_attributes(
          class: InferModel::Model,
          source_name: "happy_path",
          attributes: {
            integer_col: an_object_having_attributes(detected_type: :decimal),
            decimal_col: an_object_having_attributes(detected_type: :decimal),
            datetime_col: an_object_having_attributes(detected_type: :datetime),
            time_col: an_object_having_attributes(detected_type: :string),
            boolean_col: an_object_having_attributes(detected_type: :boolean),
            json_col: an_object_having_attributes(detected_type: :string),
            uuid_col: an_object_having_attributes(detected_type: :string),
            string_col: an_object_having_attributes(detected_type: :string),
          },
        )
      end
    end
  end
end
