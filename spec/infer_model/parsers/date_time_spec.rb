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
      context "as offset" do
        let(:opts) { { time_zone_offset: "+00:00" } }

        it "respects that assertion" do
          expect(result).to eq(DateTime.new(2021, 6, 5, 9, 18))
        end
      end

      context "as name" do
        let(:opts) { { time_zone: "UTC" } }

        it "respects that assertion" do
          expect(result).to eq(DateTime.new(2021, 6, 5, 9, 18))
        end
      end
    end

    context "Europe/Berlin" do
      # the zoneless value of "05.06.2021 09:18" shall be interpreted as german time
      # that is "2021-06-05T09:18:00+02:00", which equals "2021-06-05T07:18:00Z"
      context "as offset" do
        let(:opts) { { time_zone_offset: "+02:00" } }

        it "respects that assertion" do
          expect(result).to eq(DateTime.new(2021, 6, 5, 7, 18))
        end
      end

      context "as name" do
        let(:opts) { { time_zone: "Europe/Berlin" } }

        it "respects that assertion" do
          expect(result).to eq(DateTime.new(2021, 6, 5, 7, 18))
        end
      end
    end

    context "Unknown/TimeZone" do
      context "as offset" do
        # the zoneless value of "05.06.2021 09:18" shall be interpreted as
        # "2021-06-05T09:18:00+23:45", which equals "2021-06-05T07:18:00Z"
        let(:opts) { { time_zone_offset: "+23:45" } }

        it "respects that assertion" do
          expect(result).to eq(DateTime.new(2021, 6, 4, 9, 33))
        end
      end

      context "as name" do
        let(:opts) { { time_zone: "Unknown/TimeZone" } }

        it "raises an error" do
          expect { subject }.to raise_error(ArgumentError, "Invalid Timezone: Unknown/TimeZone")
        end
      end
    end
  end
end
