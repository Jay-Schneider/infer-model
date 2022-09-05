# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::CommonType do
  describe "#==" do
    context "for one type" do
      subject { described_class.new(:decimal) }

      it { is_expected.to eq(:decimal) }
    end

    context "for multiple types" do
      subject { described_class.new(%i[decimal datetime uuid]) }

      it { is_expected.to eq(%i[decimal datetime uuid]) }
    end
  end

  describe "#inspect" do
    context "for one type" do
      subject { described_class.new(:decimal).inspect }

      it { is_expected.to eq("<InferModel::CommonType: decimal>") }

      context "with unique_constraint_possible" do
        subject { described_class.new(:decimal, unique_constraint_possible: true).inspect }

        it { is_expected.to eq("<InferModel::CommonType: decimal, only unique values>") }
      end

      context "with non_null_constraint_possible" do
        subject { described_class.new(:decimal, non_null_constraint_possible: true).inspect }

        it { is_expected.to eq("<InferModel::CommonType: decimal, no empty values>") }
      end

      context "with unique_constraint_possible & non_null_constraint_possible" do
        subject { described_class.new(:decimal, unique_constraint_possible: true, non_null_constraint_possible: true).inspect }

        it { is_expected.to eq("<InferModel::CommonType: decimal, only unique values, no empty values>") }
      end
    end

    context "for multiple types" do
      subject { described_class.new(%i[decimal datetime uuid]).inspect }

      it { is_expected.to eq("<InferModel::CommonType: [:decimal, :datetime, :uuid]>") }

      context "with unique_constraint_possible" do
        subject { described_class.new(%i[decimal datetime uuid], unique_constraint_possible: true).inspect }

        it { is_expected.to eq("<InferModel::CommonType: [:decimal, :datetime, :uuid], only unique values>") }
      end

      context "with non_null_constraint_possible" do
        subject { described_class.new(%i[decimal datetime uuid], non_null_constraint_possible: true).inspect }

        it { is_expected.to eq("<InferModel::CommonType: [:decimal, :datetime, :uuid], no empty values>") }
      end

      context "with unique_constraint_possible & non_null_constraint_possible" do
        subject { described_class.new(%i[decimal datetime uuid], unique_constraint_possible: true, non_null_constraint_possible: true).inspect }

        it { is_expected.to eq("<InferModel::CommonType: [:decimal, :datetime, :uuid], only unique values, no empty values>") }
      end
    end
  end
end
