require_relative '../../lib/policy_ocr/file_processor'
require_relative '../../lib/policy_ocr/errors'

describe PolicyOcr::FileProcessor do
  describe "#import" do
    subject { handler.import(input_file) }

    let(:handler) { described_class.new }
    let(:input_file) { fixture_path('sample.txt') }


    it "imports file and generates policy numbers" do
      subject
      expect(handler.policy_numbers.map { |p| p.number }).to eq(
        [
          "000000000",
          "111111111",
          "222222222",
          "333333333",
          "444444444",
          "555555555",
          "666666666",
          "777777777",
          "888888888",
          "999999999",
          "123456789"
        ]
      )
    end

    context 'when given an invalid file' do
      let(:input_file) { fixture_path('samplex.txt') }

      it 'raises an FileProcessingError' do
        expect { subject }.to raise_error(PolicyOcr::FileProcessingError)
      end
    end
  end

  describe "#export" do
    subject { handler.export(output_path) }

    before do
      File.write(output_path, '') if File.exist?(output_path)
      handler.import(input_file)
    end

    let(:handler) { described_class.new }
    let(:input_file) { fixture_path('sample.txt') }
    let(:output_path) { "tmp/output.txt" }


    it "exports policy numbers to output file" do
      subject
      result = File.read(output_path).split("\n")
      expect(result).to eq([
        "000000000",
        "711111111",
        "222222222 ERR",
        "333393333",
        "444444444 ERR",
        "555555555 AMB",
        "666666666 AMB",
        "777777177",
        "888888888 AMB",
        "999999999 AMB",
        "123456789"
      ])
    end
  end

  describe "#perform" do
    subject { described_class.perform(input_file, output_path) }

    before do
      File.write(output_path, '') if File.exist?(output_path)
    end

    let(:input_file) { fixture_path('sample.txt') }
    let(:output_path) { "tmp/output.txt" }


    it "exports policy numbers to output file" do
      subject
      result = File.read(output_path).split("\n")
      expect(result).to eq([
        "000000000",
        "711111111",
        "222222222 ERR",
        "333393333",
        "444444444 ERR",
        "555555555 AMB",
        "666666666 AMB",
        "777777177",
        "888888888 AMB",
        "999999999 AMB",
        "123456789"
      ])
    end
  end
end
