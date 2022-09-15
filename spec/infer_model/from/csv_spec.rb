# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::From::CSV do
  describe "#call" do
    subject(:result) { described_class.call("spec/fixtures/csv/happy_path.csv") }

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
      subject(:result) { described_class.call("spec/fixtures/csv/happy_path.csv", available_types:) }

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

    context "when rename_attributes is given" do
      subject(:result) { described_class.call("spec/fixtures/csv/happy_path.csv", rename_attributes:) }

      context "as a hash" do
        let(:rename_attributes) do
          {
            integer_col: :some_unique_present_number,
            decimal_col: :a_floating_number,
            datetime_col: :birthday,
            time_col: :some_time,
            boolean_col: :truthSpoken?,
            uuid_col: :unique_uuid,
          }
        end

        it "renames the specified keys and keeps the others" do
          expect(result).to have_attributes(
            class: InferModel::Model,
            source_name: "happy_path",
            attributes: {
              some_unique_present_number: an_object_having_attributes(detected_type: :integer),
              a_floating_number: an_object_having_attributes(detected_type: :decimal),
              birthday: an_object_having_attributes(detected_type: :datetime),
              some_time: an_object_having_attributes(detected_type: :time),
              truthSpoken?: an_object_having_attributes(detected_type: :boolean),
              json_col: an_object_having_attributes(detected_type: :json),
              unique_uuid: an_object_having_attributes(detected_type: :uuid),
              string_col: an_object_having_attributes(detected_type: :string),
            },
          )
        end
      end

      context "as a proc" do
        let(:rename_attributes) do
          proc do |old_key|
            old_key == :string_col ? nil : "some_#{old_key}_with_interesting_properties".to_sym
          end
        end

        it "renames with present results and keeps the others" do
          expect(result).to have_attributes(
            class: InferModel::Model,
            source_name: "happy_path",
            attributes: {
              some_integer_col_with_interesting_properties: an_object_having_attributes(detected_type: :integer),
              some_decimal_col_with_interesting_properties: an_object_having_attributes(detected_type: :decimal),
              some_datetime_col_with_interesting_properties: an_object_having_attributes(detected_type: :datetime),
              some_time_col_with_interesting_properties: an_object_having_attributes(detected_type: :time),
              some_boolean_col_with_interesting_properties: an_object_having_attributes(detected_type: :boolean),
              some_json_col_with_interesting_properties: an_object_having_attributes(detected_type: :json),
              some_uuid_col_with_interesting_properties: an_object_having_attributes(detected_type: :uuid),
              string_col: an_object_having_attributes(detected_type: :string),
            },
          )
        end
      end
    end
  end
end
