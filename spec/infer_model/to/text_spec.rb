# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::To::Text do
  describe "#call" do
    let(:inferred_data) do
      {
        source_name: "foo_bars",
        attributes: {
          integer_col: InferModel::CommonType.new(:integer, unique_constraint_possible: true, non_null_constraint_possible: true),
          decimal_col: InferModel::CommonType.new(:decimal),
          boolean_col: InferModel::CommonType.new(:boolean, non_null_constraint_possible: true),
          uuid_col: InferModel::CommonType.new(:uuid, unique_constraint_possible: true),
        },
      }
    end

    let(:expected_text) do
      <<~TEXT
        Source Name: 'foo_bars'
        #######################

        Attributes:
        -----------

        integer_col:
          Type:     integer
          Unique:   contains only unique values
          Non null: does not contain empty values

        decimal_col:
          Type:     decimal

        boolean_col:
          Type:     boolean
          Non null: does not contain empty values

        uuid_col:
          Type:     uuid
          Unique:   contains only unique values
      TEXT
    end

    context "without a file" do
      subject(:call) { described_class.call(inferred_data, outstream:) }
      let(:outstream) { StringIO.new }
      let(:output) { outstream.tap(&:rewind).read }

      it "prints the text" do
        call
        expect(output).to eq(expected_text)
      end
    end

    context "with a file" do
      before do
        FileUtils.rm_f(target_filename)
        FileUtils.mkdir_p(File.dirname(target_filename))
      end
      subject(:call) { File.open(target_filename, "w") { |file| described_class.call(inferred_data, outstream: file) } }
      let(:target_filename) { "tmp/spec/foo_bars.txt" }

      it "writes the text into the file" do
        expect { call }.to change { File.exist?(target_filename) }.from(false).to(true)
        expect(File.read(target_filename)).to eq(expected_text)
      end
    end
  end
end
