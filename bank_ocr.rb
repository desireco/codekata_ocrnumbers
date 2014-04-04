class BankOCR
  NUMBERS = [
    " _     _  _     _  _  _  _  _ ",
    "| |  | _| _||_||_ |_   ||_||_|",
    "|_|  ||_  _|  | _||_|  ||_| _|"
  ]

  def validate_line(input_lines)
    valid = true
    valid = false if input_lines.size != 3
    input_lines.each do |l|
      valid = false if l.length != 27
    end
    valid
  end

  def recognize_numbers(input_line)
    if validate_line(input_line)
      numbers_matrices = parse_line(input_line)
      numbers = []
      numbers_matrices.each do |n|
        numbers << recognize_number(n)
      end
      numbers.join()
    else
      "* bad data *"
    end
  end

  def recognize_number(n)
    numbers = get_number_matrices()
    numbers.each_with_index do |template, i|
      return i if template == n
    end
    return "?"
  end

  def get_number_matrices
    numbers = []
    (0..9).each do |i|
      matrix = []
      NUMBERS.each do |scan_line| 
        matrix << scan_line[i*3, 3]
      end
      numbers << matrix
    end
    numbers
  end

  def parse_line(input_line)
    numbers = []
    (0..8).each do |i|
      matrix = []
      input_line.each do |scan_line| 
        matrix << scan_line[i*3, 3]
      end
      numbers << matrix
    end
    numbers
  end

  def process_file(filename)
    line_counter = 0
    number_line = []
    File.open(filename, "r") do |f|
      f.each_line do |line|
        # remove line end char
        line.gsub!(/\n?/, "")
        line_counter+=1
        if line == " " * 27
          if line_counter == 4
            puts recognize_numbers(number_line)
          else
            puts "* bad data *"
          end
          number_line = []
          line_counter = 0
        else
          number_line << line
        end
      end
    end
  end
end

#INPUT_FILE = 'numbers_file.txt'
#ocr = BankOCR.new
#ocr.process_file(INPUT_FILE)
