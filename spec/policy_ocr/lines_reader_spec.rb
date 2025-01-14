require_relative '../../lib/policy_ocr/lines_reader'

describe PolicyOcr::LinesReader do

  describe "#parse" do
    subject { described_class.parse(lines) }

    let(:lines) { [] }

    context 'with a valid entry' do
      let(:lines) do
        [
          "    _  _     _  _  _  _  _ ",
          "  | _| _||_||_ |_   ||_||_|",
          "  ||_  _|  | _||_|  ||_| _|"
        ]
      end

      it "parses correctly" do
        response = subject
        expect(response.class).to eq(PolicyOcr::PolicyNumber)
        expect(response.number).to eq("123456789")
        expect(response.valid?).to be true
      end
    end

    context 'with illegible character at the end' do
      let(:lines) do
        [
          "    _  _     _  _  _  _    ",
          "  | _| _||_||_ |_   ||_||_|",
          "  ||_  _|  | _||_|  ||_| _|"
        ]
      end

      it "returns '?' for illegible characters" do
        policy = subject
        expect(policy.number).to eq("12345678?")
        expect(policy.valid?).to be false
        expect(policy.illegible_count).to eq(1)
      end
    end

    context 'with illegible character in between' do
      let(:lines) do
        [
          "    _  _     _     _  _  _ ",
          "  | _| _||_||_ |_   ||_||_|",
          "  ||_  _|  | _||_|  ||_| _|"
        ]
      end

      it "returns '?' for illegible characters" do
        policy = subject
        expect(policy.number).to eq("12345?789")
        expect(policy.valid?).to be false
        expect(policy.illegible_count).to eq(1)
      end
    end

    context 'with multiple illegible characters' do
      let(:lines) do
        [
          "    _  _     _     _  _  _ ",
          "  | _|  ||_||_ |_   ||_||_|",
          "  ||_  _|  | _||_|  ||_| _|"
        ]
      end

      it "returns correct illegible count" do
        policy = subject
        expect(policy.number).to eq("12?45?789")
        expect(policy.valid?).to be false
        expect(policy.illegible_count).to eq(2)
      end
    end
  end
end
