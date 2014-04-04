class BankOCR
  NUMBERS = [
    " _     _  _     _  _  _  _  _ ",
    "| |  | _| _||_||_ |_   ||_||_|",
    "|_|  ||_  _|  | _||_|  ||_| _|"
  ]

  def initialize
    @number_matrices = get_number_matrices()
  end

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
    @number_matrices.each_with_index do |template, i|
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

  def recognition_status(result)
    if result.match(/\?/)
      return "ILL"
    elsif !calculate_checksum(result)
      return "ERR"
    else
      return ""
    end
  end

  def process_record(lines)
    result = recognize_numbers(lines)
    puts "#{result} #{recognition_status(result)}"
  end

  def process_file(filename)
    doc = File.open(filename, "r").read()
    lines = doc.split("\n")
    process_record(lines)
  end

  def calculate_checksum(numbers)
    i = 0
    checksum = numbers.reverse.split("").inject(0) do |checksum, n|
      i += 1
      checksum + n.to_i * i 
    end
    return checksum % 11 == 0
  end
end

if defined?(ARGV) && ARGV.size > 0
  filename = ARGV.first
  ocr = BankOCR.new
  ocr.process_file(filename)
end
