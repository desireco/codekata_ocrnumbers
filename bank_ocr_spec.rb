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

    it "returns array of 10 matrices" do
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
      number_5 = []
      number_5 << " _ "
      number_5 << "|_ "
      number_5 << " _|"
      expect(numbers[4]).to eq(number_5)
    end
    it "returns proper matrix for 9" do
      numbers = ocr.parse_line(inp)
      number_9 = []
      number_9 << " _ "
      number_9 << "|_|"
      number_9 << " _|"
      expect(numbers[8]).to eq(number_9)
    end
  end

  context "#recognize_number" do
    let (:number_def) do
      inp = [
        " _     _  _     _  _  _  _  _ ",
        "| |  | _| _||_||_ |_   ||_||_|",
        "|_|  ||_  _|  | _||_|  ||_| _|"
      ]
    end

    it "can recognize valid numbers" do
      ocr.parse_line(number_def).each_with_index do |n, i|
        expect(ocr.recognize_number(n)).to eq(i)
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

    it "recognize zero" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        "| || || || || || || || || |",
        "|_||_||_||_||_||_||_||_||_|"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("000000000")
    end

    it "recognize one" do
      inp = [
        "                           ",
        "  |  |  |  |  |  |  |  |  |",
        "  |  |  |  |  |  |  |  |  |"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("111111111")
    end

    it "recognize two" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        " _| _| _| _| _| _| _| _| _|",
        "|_ |_ |_ |_ |_ |_ |_ |_ |_ "
      ]
      expect(ocr.recognize_numbers(inp)).to eq("222222222")
    end

    it "recognize three" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        " _| _| _| _| _| _| _| _| _|",
        " _| _| _| _| _| _| _| _| _|"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("333333333")
    end

    it "recognize four" do
      inp = [
        "                           ",
        "|_||_||_||_||_||_||_||_||_|",
        "  |  |  |  |  |  |  |  |  |"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("444444444")
    end

    it "recognize five" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        "|_ |_ |_ |_ |_ |_ |_ |_ |_ ",
        " _| _| _| _| _| _| _| _| _|"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("555555555")
    end


    it "recognize six" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        "|_ |_ |_ |_ |_ |_ |_ |_ |_ ",
        "|_||_||_||_||_||_||_||_||_|"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("666666666")
    end


    it "recognize seven" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        "  |  |  |  |  |  |  |  |  |",
        "  |  |  |  |  |  |  |  |  |"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("777777777")
    end

    it "recognize eight" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        "|_||_||_||_||_||_||_||_||_|",
        "|_||_||_||_||_||_||_||_||_|"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("888888888")
    end

    it "recognize nine" do
      inp = [
        " _  _  _  _  _  _  _  _  _ ",
        "|_||_||_||_||_||_||_||_||_|",
        " _| _| _| _| _| _| _| _| _|"
      ]
      expect(ocr.recognize_numbers(inp)).to eq("999999999")
    end

    it "reports on lines that are invalid" do
      inp = []
      inp << "   _  _     _  _  _  _  _ "
      inp << " | _| _||_||_ |_   ||_||_| " # this line is longer
      inp << " ||_  _|  | _||_|  ||_| _|"
      expect(ocr.recognize_numbers(inp)).to eq("* bad data *")
    end
  end

  context "user story 2 - calculate checksum" do
    it "calculate checksum" do
      expect(ocr.calculate_checksum("711111111")).to be_true
      expect(ocr.calculate_checksum("123456789")).to be_true
      expect(ocr.calculate_checksum("490867715")).to be_true

      expect(ocr.calculate_checksum("888888888")).to be_false
      expect(ocr.calculate_checksum("490067715")).to be_false
      expect(ocr.calculate_checksum("012345678")).to be_false
    end
  end

  context "user story 3 - display status" do
    it "displays no error status with nothing" do
      expect(ocr.recognition_status("000000051")).to eq("")
    end

    it "displays ILL for not recognized chars" do
      expect(ocr.recognition_status("49006771?")).to eq("ILL")
      expect(ocr.recognition_status("1234?678?")).to eq("ILL")
    end

    it "displays ERR for failed checksum" do
      expect(ocr.recognition_status("888888888")).to eq("ERR")
    end
  end
end
