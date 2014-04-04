require 'rspec'
require "./bank_ocr"

describe "Bank OCR" do
  let(:ocr) { BankOCR.new}
  context "reading and processing file" do
    it 'validates line to be 3 lines 27 chars long' do
      inp_lines = []
      3.times { inp_lines << " " * 27}
      expect(ocr.validate_line(inp_lines)).to be_true
    end

    it '4 line input is not valid' do
      inp_lines = []
      4.times { inp_lines << " " * 27}
      expect(ocr.validate_line(inp_lines)).to be_false
    end

    it '2 line input is not valid' do
      inp_lines = []
      2.times { inp_lines << " " * 27}
      expect(ocr.validate_line(inp_lines)).to be_false
    end

    it 'input with lines not exactly 27 chars is not valid' do
      inp_lines = []
      inp_lines << " " * 27
      inp_lines << " " * 26
      inp_lines << " " * 27
      expect(ocr.validate_line(inp_lines)).to be_false

      inp_lines = []
      inp_lines << " " * 27
      inp_lines << " " * 28
      inp_lines << " " * 27
      expect(ocr.validate_line(inp_lines)).to be_false
    end
  end

  context "#parse_line" do
    let (:inp) do
      inp = [
        "    _  _     _  _  _  _  _ ",
        "  | _| _||_||_ |_   ||_||_|",
        "  ||_  _|  | _||_|  ||_| _|"
      ]
    end

    it "returns array of 9 matrices" do
      numbers = ocr.parse_line(inp)
      expect(numbers.size).to eq(9)
    end

    it "returns proper matrix for 1" do
      numbers = ocr.parse_line(inp)
      number_1 = []
      number_1 << "   "
      number_1 << "  |"
      number_1 << "  |"
      expect(numbers[0]).to eq(number_1)
    end

    it "returns proper matrix for 5" do
      numbers = ocr.parse_line(inp)
      number_1 = []
      number_1 << " _ "
      number_1 << "|_ "
      number_1 << " _|"
      expect(numbers[4]).to eq(number_1)
    end
  end

  context "#recognize_number" do
    let (:number_def) do
      inp = [
        "    _  _     _  _  _  _  _ ",
        "  | _| _||_||_ |_   ||_||_|",
        "  ||_  _|  | _||_|  ||_| _|"
      ]
    end

    it "can recognize valid numbers" do
      ocr.parse_line(number_def).each_with_index do |n, i|
        expect(ocr.recognize_number(n)).to eq(i + 1)
      end
    end

    it "will mark invalid numbers with nil" do
      wrong_matrix = [
        "   ",
        " _|",
        "  |"
      ]

      expect(ocr.recognize_number(wrong_matrix)).to eq("?")
    end
  end

  context "user story 1 - read line of numbers" do
    it "read line with numbers" do
      inp = []
      inp << "    _  _     _  _  _  _  _ "
      inp << "  | _| _||_||_ |_   ||_||_|"
      inp << "  ||_  _|  | _||_|  ||_| _|"
      expect(ocr.recognize_numbers(inp)).to eq("123456789")
    end

    it "reports on lines that are invalid" do
      inp = []
      inp << "   _  _     _  _  _  _  _ "
      inp << " | _| _||_||_ |_   ||_||_| " # this line is longer
      inp << " ||_  _|  | _||_|  ||_| _|"
      expect(ocr.recognize_numbers(inp)).to eq("* bad data *")
    end
  end
end
