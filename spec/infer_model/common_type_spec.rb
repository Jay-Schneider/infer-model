# frozen_string_literal: true

require "spec_helper"

RSpec.describe InferModel::CommonType do
  describe "#detected_type" do
    subject(:detected_type) { common_type.detected_type }

    context "when it has one" do
      let(:common_type) { InferModel::CommonType.new(:decimal) }

      it "returns it" do
        expect(detected_type).to eq(:decimal)
      end
    end

    context "when it has multiple" do
      let(:common_type) { InferModel::CommonType.new(%i[integer decimal]) }

      it "returns the first one" do
        expect(detected_type).to eq(:integer)
      end
    end
  end
end
