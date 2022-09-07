# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::ValueTypeGuesser do
  describe "#call" do
    context "in single mode" do
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
        "" => :integer,
        nil => :integer,
      }

      input_expected_output_matrix.each do |input, expected_output|
        context "for #{input}" do
          subject { described_class.call(input) }

          it { is_expected.to eq(expected_output) }
        end
      end

      context "when available_types are restricted" do
        available_types = %i[decimal integer boolean]
        input_expected_output_matrix = {
          "12.5" => :decimal,
          "1234.5" => :decimal,
          "1_234.5" => :decimal,
          "FALSE" => :boolean,
          "true" => :boolean,
          "F" => :boolean,
          "12,5" => nil, # care when processing localized data
          "2011-12-28" => nil,
          "2011-12-28T" => nil,
          "2011-12-28T00:05:12" => nil,
          "2011-12-28T00:05:12+0200" => nil,
          "2011-12-28T00:05:12+02:00" => nil,
          "24.08.2015 00:05" => nil,
          "24.08.2015 00:05:12" => nil,
          "24.08.2015 00:05:12+0200" => nil,
          "24.08.2015 00:05:12+02:00" => nil,
          "07:28:45" => nil,
          "07:28" => nil,
          '{"foo": "bar", "baz": 23}' => nil,
          '"I am a string with double quotes, hence valid JSON"' => nil,
          "123" => :integer,
          "123_456" => :integer,
          "ccec0361-3d68-4db8-95ce-b5bf4f6d3924" => nil,
          "foo" => nil,
          "" => :integer,
          nil => :integer,
        }

        input_expected_output_matrix.each do |input, expected_output|
          context "for #{input}" do
            subject { described_class.call(input, available_types:) }

            it { is_expected.to eq(expected_output) }
          end
        end
      end
    end

    context "in multi mode" do
      input_expected_output_matrix = {
        "12.5" => %i[decimal json string],
        "1234.5" => %i[decimal json string],
        "1_234.5" => %i[decimal string],
        "FALSE" => %i[boolean string],
        "true" => %i[boolean json string],
        "F" => %i[boolean string],
        "12,5" => %i[string], # care when processing localized data
        "2011-12-28" => %i[datetime string],
        "2011-12-28T" => %i[datetime string],
        "2011-12-28T00:05:12" => %i[datetime string],
        "2011-12-28T00:05:12+0200" => %i[datetime string],
        "2011-12-28T00:05:12+02:00" => %i[datetime string],
        "24.08.2015 00:05" => %i[datetime string],
        "24.08.2015 00:05:12" => %i[datetime string],
        "24.08.2015 00:05:12+0200" => %i[datetime string],
        "24.08.2015 00:05:12+02:00" => %i[datetime string],
        "07:28:45" => %i[time string],
        "07:28" => %i[time string],
        '{"foo": "bar", "baz": 23}' => %i[json string],
        '"I am a string with double quotes, hence valid JSON"' => %i[json string],
        "123" => %i[integer decimal json string],
        "123_456" => %i[integer decimal string],
        "ccec0361-3d68-4db8-95ce-b5bf4f6d3924" => %i[uuid string],
        "foo" => %i[string],
        "" => %i[integer decimal boolean time datetime json uuid string],
        nil => %i[integer decimal boolean time datetime json uuid string],
      }

      input_expected_output_matrix.each do |input, expected_output|
        context "for #{input}" do
          subject { described_class.call(input, multi: true) }

          it { is_expected.to eq(expected_output) }
        end
      end

      context "when available_types are restricted" do
        available_types = %i[decimal integer boolean string]

        input_expected_output_matrix.each do |input, expected_output|
          context "for #{input}" do
            subject { described_class.call(input, available_types:, multi: true) }

            it { is_expected.to eq(expected_output & available_types) }
          end
        end
      end
    end
  end

  describe "may_be?" do
    subject { described_class.new(input).send(:may_be?, described_type) }

    context "for 42" do
      let(:input) { "42" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_truthy }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_truthy }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_falsey }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_falsey }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_falsey }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_truthy }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_falsey }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for 13.37" do
      let(:input) { "13.37" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_falsey }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_truthy }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_falsey }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_falsey }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_falsey }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_truthy }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_falsey }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for FALSE" do
      let(:input) { "FALSE" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_falsey }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_falsey }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_truthy }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_falsey }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_falsey }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_falsey }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_falsey }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for 07:28:23" do
      let(:input) { "07:28:23" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_falsey }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_falsey }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_falsey }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_truthy }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_falsey }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_falsey }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_falsey }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for 2011-12-28" do
      let(:input) { "2011-12-28" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_falsey }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_falsey }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_falsey }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_falsey }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_truthy }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_falsey }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_falsey }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context %(for '{"foo":"FOO", "bar":42}') do
      let(:input) { %({"foo":"FOO", "bar":42}) }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_falsey }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_falsey }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_falsey }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_falsey }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_falsey }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_truthy }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_falsey }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for ccec0361-3d68-4db8-95ce-b5bf4f6d3924" do
      let(:input) { "ccec0361-3d68-4db8-95ce-b5bf4f6d3924" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_falsey }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_falsey }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_falsey }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_falsey }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_falsey }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_falsey }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_truthy }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for FooBar" do
      let(:input) { "FooBar" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_falsey }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_falsey }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_falsey }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_falsey }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_falsey }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_falsey }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_falsey }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for empty string" do
      let(:input) { "" }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_truthy }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_truthy }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_truthy }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_truthy }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_truthy }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_truthy }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_truthy }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end

    context "for nil" do
      let(:input) { nil }

      context "with type integer" do
        let(:described_type) { :integer }
        it { is_expected.to be_truthy }
      end
      context "with type decimal" do
        let(:described_type) { :decimal }
        it { is_expected.to be_truthy }
      end
      context "with type boolean" do
        let(:described_type) { :boolean }
        it { is_expected.to be_truthy }
      end
      context "with type time" do
        let(:described_type) { :time }
        it { is_expected.to be_truthy }
      end
      context "with type datetime" do
        let(:described_type) { :datetime }
        it { is_expected.to be_truthy }
      end
      context "with type json" do
        let(:described_type) { :json }
        it { is_expected.to be_truthy }
      end
      context "with type uuid" do
        let(:described_type) { :uuid }
        it { is_expected.to be_truthy }
      end
      context "with type string" do
        let(:described_type) { :string }
        it { is_expected.to be_truthy }
      end
    end
  end
end
