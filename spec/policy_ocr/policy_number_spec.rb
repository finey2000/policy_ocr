require_relative '../../lib/policy_ocr/file_processor'
require_relative '../../lib/policy_ocr/digits'
require_relative '../../lib/policy_ocr/errors'

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

    context 'when given a non strong' do
      let(:number) { nil }

      it "raises an error" do
        expect { subject }.to raise_error(PolicyOcr::InvalidPolicyNumberError, 'Number must be a valid string')
      end
    end

    context 'when given an empty string' do
      let(:number) { '' }

      it 'raises an InvalidPolicyNumberError' do
        expect { subject }.to raise_error(PolicyOcr::InvalidPolicyNumberError, 'Number must be a valid string')
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

  describe "#guess_corrections" do
    subject { policy.send(:guess_corrections) }

    let(:policy) { described_class.new(number, encoded_form: encoded_form, run_checks: false) }
    let(:number) { '' }
    let(:encoded_form) { [] }

    context 'when given a valid number with invalid checksum' do
      let(:number) { '111111111' }

      let(:encoded_form) do
        [
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE
        ]
      end

      it "returns possible corrections" do
        expect(subject).to eq(
          [
            "711111111",
            "171111111",
            "117111111",
            "111711111",
            "111171111",
            "111117111",
            "111111711",
            "111111171",
            "111111117"
          ]
        )
      end
    end
  end

  describe "#validate_and_correct" do
    subject { policy.validate_and_correct }

    let(:policy) { described_class.new(number, encoded_form: encoded_form, run_checks: true) }
    let(:number) { '' }
    let(:encoded_form) { [] }

    context 'when given a valid number with invalid checksum' do
      let(:number) { '111111111' }

      let(:encoded_form) do
        [
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::ONE
        ]
      end

      it "returns possible corrections" do
        expect(subject).to eq(['711111111'])
      end
    end

    context 'when given a valid number 777777777' do
      let(:number) { '777777777' }

      let(:encoded_form) do
        [
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN
        ]
      end

      it "returns possible corrections" do
        expect(subject).to eq(['777777177'])
      end
    end

    context 'when given a malformed number' do
      let(:number) { '77777717?' }

      let(:encoded_form) do
        [
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::SEVEN,
          PolicyOcr::Digits::ONE,
          PolicyOcr::Digits::SEVEN,
          " | " +
          "  |" +
          "  |"
        ]
      end

      it "returns possible corrections" do
        expect(subject).to eq(['777777177'])
      end
    end
  end
end
