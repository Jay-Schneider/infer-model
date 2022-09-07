# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::CommonTypeGuesser do
  describe "#call" do
    describe "#possible_detected_types" do
      context "in single mode" do
        input_expected_output_matrix = {
          ["12.5", "1234.5", "1_234.5"] => :decimal,
          ["12.5", "1234.5", "1_234.5", "12,5"] => :string,
          %w[12 1234 1_234 12] => :integer,
          %w[false true f t F T False True FALSE TRUE] => :boolean,
          %w[false true falsch T] => :string,
          [
            "2011-12-28",
            "2011-12-28T",
            "2011-12-28T00:05:12",
            "2011-12-28T00:05:12+0200",
            "2011-12-28T00:05:12+02:00",
            "24.08.2015 00:05",
            "24.08.2015 00:05:12",
            "24.08.2015 00:05:12+0200",
            "24.08.2015 00:05:12+02:00",
          ] => :datetime,
          ["07:28:45", "07:28"] => :time,
          ["07:28:45", "12", "07:28"] => :string,
          ['{"foo": "bar", "baz": 23}', '"I am a string with double quotes, hence valid JSON"'] => :json,
          %w[123 123_456] => :integer,
          %w[x 123 123_456] => :string,
          ["ccec0361-3d68-4db8-95ce-b5bf4f6d3924"] => :uuid,
          %w[foo bar] => :string,
        }

        input_expected_output_matrix.each do |inputs, expected_output|
          context "for #{inputs}" do
            subject { described_class.call(inputs).possible_detected_types }

            it { is_expected.to eq(expected_output) }
          end
        end

        context "when available_types are restricted" do
          available_types = %i[decimal uuid datetime string]
          input_expected_output_matrix = {
            ["12.5", "1234.5", "1_234.5"] => :decimal,
            ["12.5", "1234.5", "1_234.5", "12,5"] => :string,
            %w[12 1234 1_234 12] => :decimal,
            %w[false true f t F T False True FALSE TRUE] => :string,
            %w[false true falsch T] => :string,
            [
              "2011-12-28",
              "2011-12-28T",
              "2011-12-28T00:05:12",
              "2011-12-28T00:05:12+0200",
              "2011-12-28T00:05:12+02:00",
              "24.08.2015 00:05",
              "24.08.2015 00:05:12",
              "24.08.2015 00:05:12+0200",
              "24.08.2015 00:05:12+02:00",
            ] => :datetime,
            ["07:28:45", "07:28"] => :string,
            ["07:28:45", "12", "07:28"] => :string,
            ['{"foo": "bar", "baz": 23}', '"I am a string with double quotes, hence valid JSON"'] => :string,
            %w[123 123_456] => :decimal,
            %w[x 123 123_456] => :string,
            ["ccec0361-3d68-4db8-95ce-b5bf4f6d3924"] => :uuid,
            %w[foo bar] => :string,
          }

          input_expected_output_matrix.each do |inputs, expected_output|
            context "for #{inputs}" do
              subject { described_class.call(inputs, available_types:).possible_detected_types }

              it { is_expected.to eq(expected_output) }
            end
          end
        end

        context "when constraint detection is enabled" do
          subject { described_class.call(inputs, detect_uniqueness: true, detect_non_null: true) }

          context "when inputs are unique and not empty" do
            let(:inputs) { %w[12 23 34 45 56 67] }
            it { is_expected.to have_attributes(possible_detected_types: :integer, unique_constraint_possible: true, non_null_constraint_possible: true) }
          end

          context "when inputs are unique on string level but map to the same value when parsed" do
            let(:inputs) { %w[1 01] }
            it { is_expected.to have_attributes(possible_detected_types: :integer, unique_constraint_possible: false) }
          end

          context "when inputs are unique but include empty ones" do
            let(:inputs) { ["12", "23", "34", "", "56", "67"] }
            it { is_expected.to have_attributes(possible_detected_types: :integer, unique_constraint_possible: true, non_null_constraint_possible: false) }
          end

          context "when inputs are not unique but not empty" do
            let(:inputs) { %w[12 23 34 45 56 34 67] }
            it { is_expected.to have_attributes(possible_detected_types: :integer, unique_constraint_possible: false, non_null_constraint_possible: true) }
          end

          context "when inputs are not unique and include empty ones" do
            let(:inputs) { ["12", "23", "34", "", "56", "34", "67"] }
            it { is_expected.to have_attributes(possible_detected_types: :integer, unique_constraint_possible: false, non_null_constraint_possible: false) }
          end
        end
      end
    end

    describe "#possible_detected_types" do
      context "in multi mode" do
        input_expected_output_matrix = {
          ["12.5", "1234.5", "1_234.5"] => %i[decimal string],
          ["12.5", "1234.5", "1_234.5", "12,5"] => %i[string],
          %w[12 1234 1_234 12] => %i[integer decimal string],
          %w[false true f t F T False True FALSE TRUE] => %i[boolean string],
          %w[false true falsch T] => %i[string],
          [
            "2011-12-28",
            "2011-12-28T",
            "2011-12-28T00:05:12",
            "2011-12-28T00:05:12+0200",
            "2011-12-28T00:05:12+02:00",
            "24.08.2015 00:05",
            "24.08.2015 00:05:12",
            "24.08.2015 00:05:12+0200",
            "24.08.2015 00:05:12+02:00",
          ] => %i[datetime string],
          ["07:28:45", "07:28"] => %i[time string],
          ["07:28:45", "12", "07:28"] => %i[string],
          ['{"foo": "bar", "baz": 23}', '"I am a string with double quotes, hence valid JSON"'] => %i[json string],
          %w[123 123_456] => %i[integer decimal string],
          %w[x 123 123_456] => %i[string],
          ["ccec0361-3d68-4db8-95ce-b5bf4f6d3924"] => %i[uuid string],
          %w[foo bar] => %i[string],
        }

        input_expected_output_matrix.each do |inputs, expected_output|
          context "for #{inputs}" do
            subject { described_class.call(inputs, multi: true).possible_detected_types }

            it { is_expected.to eq(expected_output) }
          end
        end

        context "when available_types are restricted" do
          available_types = %i[decimal uuid datetime string]

          input_expected_output_matrix.each do |inputs, expected_output|
            context "for #{inputs}" do
              subject { described_class.call(inputs, available_types:, multi: true).possible_detected_types }

              it { is_expected.to eq(expected_output & available_types) }
            end
          end
        end
      end

      context "when constraint detection is enabled" do
        subject { described_class.call(inputs, multi: true, detect_uniqueness: true, detect_non_null: true) }

        context "when inputs are unique and not empty" do
          let(:inputs) { %w[12 23 34 45 56 67] }
          it { is_expected.to have_attributes(possible_detected_types: %i[integer decimal json string], unique_constraint_possible: true, non_null_constraint_possible: true) }
        end

        context "when inputs are unique but include empty ones" do
          let(:inputs) { ["12", "23", "34", "", "56", "67"] }
          it { is_expected.to have_attributes(possible_detected_types: %i[integer decimal json string], unique_constraint_possible: true, non_null_constraint_possible: false) }
        end

        context "when inputs are not unique but not empty" do
          let(:inputs) { %w[12 23 34 45 56 34 67] }
          it { is_expected.to have_attributes(possible_detected_types: %i[integer decimal json string], unique_constraint_possible: false, non_null_constraint_possible: true) }
        end

        context "when inputs are not unique and include empty ones" do
          let(:inputs) { ["12", "23", "34", "", "56", "34", "67"] }
          it { is_expected.to have_attributes(possible_detected_types: %i[integer decimal json string], unique_constraint_possible: false, non_null_constraint_possible: false) }
        end
      end
    end
  end
end
