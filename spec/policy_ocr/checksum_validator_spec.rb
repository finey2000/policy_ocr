require_relative '../../lib/policy_ocr/checksum_validator'

describe PolicyOcr::ChecksumValidator do

  describe "#valid?" do
    subject { described_class.valid?(number) }

    let(:number) { '' }

    context "when its a valid checksum" do
      let(:number) { "457508000" }

      it { is_expected.to be true }
    end

    context "when its an valid checksum" do
      let(:number) { "664371495" }

      it { is_expected.to be false }
    end

    context "when its an empty string" do
      let(:number) { "" }

      it { is_expected.to be false }
    end

    context "when its nil" do
      let(:number) { nil }

      it { is_expected.to be false }
    end
  end
end
