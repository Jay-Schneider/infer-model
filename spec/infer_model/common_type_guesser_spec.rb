# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::CommonTypeGuesser do
  describe "#call" do
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
          subject { described_class.call(inputs) }

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
            subject { described_class.call(inputs, available_types:) }

            it { is_expected.to eq(expected_output) }
          end
        end
      end
    end

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
          subject { described_class.call(inputs, multi: true) }

          it { is_expected.to eq(expected_output) }
        end
      end

      context "when available_types are restricted" do
        available_types = %i[decimal uuid datetime string]

        input_expected_output_matrix.each do |inputs, expected_output|
          context "for #{inputs}" do
            subject { described_class.call(inputs, available_types:, multi: true) }

            it { is_expected.to eq(expected_output & available_types) }
          end
        end
      end
    end
  end
end
