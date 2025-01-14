require_relative '../../lib/policy_ocr/file_processor'

describe PolicyOcr::PolicyNumber do

  describe "#new" do
    subject { described_class.new(number) }

    let(:number) { '' }

    context 'when given a valid number' do
      let(:number) { '457508000' }

      it "returns a valid policy number" do
        policy = subject
        expect(policy.valid?).to be true
      end
    end

    context 'when given an invalid number' do
      let(:number) { '86110??36' }

      it "returns an invalid policy number" do
        policy = subject
        expect(policy.valid?).to be false
      end
    end
  end

  describe "#to_str" do
    subject { policy.to_str }

    let(:policy) { described_class.new(number) }
    let(:number) { '' }

    context 'when given a valid number' do
      let(:number) { '457508000' }

      it "returns policy number string" do
        expect(subject).to eq('457508000')
      end
    end

    context 'when given an invalid checksum number' do
      let(:number) { '664371495' }

      it "returns a number with ERR code" do
        expect(subject).to eq('664371495 ERR')
      end
    end

    context 'when given illegible number' do
      let(:number) { '86110??36' }

      it "returns a number with ERR code" do
        expect(subject).to eq('86110??36 ILL')
      end
    end
  end
end
