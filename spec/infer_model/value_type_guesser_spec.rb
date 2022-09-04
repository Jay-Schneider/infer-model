# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::ValueTypeGuesser do
  describe "#call" do
    input_expected_output_matrix = {
      "12.5" => :decimal,
      "1234.5" => :decimal,
      "1_234.5" => :decimal,
      "FALSE" => :boolean,
      "true" => :boolean,
      "F" => :boolean,
      "12,5" => :string, # care when processing localized data
      "2011-12-28" => :datetime,
      "2011-12-28T" => :datetime,
      "2011-12-28T00:05:12" => :datetime,
      "2011-12-28T00:05:12+0200" => :datetime,
      "2011-12-28T00:05:12+02:00" => :datetime,
      "24.08.2015 00:05" => :datetime,
      "24.08.2015 00:05:12" => :datetime,
      "24.08.2015 00:05:12+0200" => :datetime,
      "24.08.2015 00:05:12+02:00" => :datetime,
      "07:28:45" => :time,
      "07:28" => :time,
      '{"foo": "bar", "baz": 23}' => :json,
      '"I am a string with double quotes, hence valid JSON"' => :json,
      "123" => :integer,
      "123_456" => :integer,
      "ccec0361-3d68-4db8-95ce-b5bf4f6d3924" => :uuid,
      "foo" => :string,
    }

    input_expected_output_matrix.each do |input, expected_output|
      context "for #{input}" do
        subject { described_class.call(input) }

        it { is_expected.to eq(expected_output) }
      end
    end
  end

  describe "internals" do
    subject { described_class.new(input).send(described_method) }

    context "for 42" do
      let(:input) { "42" }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end

    context "for 13.37" do
      let(:input) { "13.37" }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end

    context "for FALSE" do
      let(:input) { "FALSE" }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end

    context "for 07:28:23" do
      let(:input) { "07:28:23" }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end

    context "for 2011-12-28" do
      let(:input) { "2011-12-28" }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end

    context %(for '{"foo":"FOO", "bar":42}') do
      let(:input) { %({"foo":"FOO", "bar":42}) }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end

    context "for ccec0361-3d68-4db8-95ce-b5bf4f6d3924" do
      let(:input) { "ccec0361-3d68-4db8-95ce-b5bf4f6d3924" }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_truthy }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end

    context "for FooBar" do
      let(:input) { "FooBar" }

      describe "#may_be_integer?" do
        let(:described_method) { :may_be_integer? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_decimal?" do
        let(:described_method) { :may_be_decimal? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_boolean?" do
        let(:described_method) { :may_be_boolean? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_time?" do
        let(:described_method) { :may_be_time? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_datetime?" do
        let(:described_method) { :may_be_datetime? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_json?" do
        let(:described_method) { :may_be_json? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_uuid?" do
        let(:described_method) { :may_be_uuid? }
        it { is_expected.to be_falsey }
      end
      describe "#may_be_string?" do
        let(:described_method) { :may_be_string? }
        it { is_expected.to be_truthy }
      end
    end
  end
end
