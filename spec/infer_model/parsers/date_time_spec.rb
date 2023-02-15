require "spec_helper"

RSpec.describe InferModel::Parsers::DateTime do
  let(:opts) { {} }
  let(:value) { "05.06.2021 09:18" }
  subject(:result) { described_class.call(value, **opts) }

  it "assumes UTC time" do
    expect(result).to eq(DateTime.new(2021, 6, 5, 9, 18))
  end

  context "with specific time zone" do
    context "utc" do
      let(:opts) { { time_zone_offset: "+00:00" } }

      it "respects that assertion" do
        expect(result).to eq(DateTime.new(2021, 6, 5, 9, 18))
      end
    end

    context "Europe/Berlin" do
      let(:opts) { { time_zone_offset: "+02:00" } }

      it "respects that assertion" do
        expect(result).to eq(DateTime.new(2021, 6, 5, 7, 18))
      end
    end
  end
end
