require 'rspec'

class NumbersString

  attr_reader :delimiter_expression



  def initialize(input)
    @input = input
    @delimiter_expression = /[,\n]/
    parse_delimiter
  end



  def numbers
    numbers_as_string.map { |value| value.to_i }
  end



  private

  def numbers_as_string
    data_string.split delimiter_expression
  end



  def parse_delimiter
    if has_delimiter?
      @delimiter_expression = ";"
    end
  end



  def has_delimiter?
    @input.start_with? "//"
  end



  def data_string
    return @input[4..-1] if has_delimiter?
    @input
  end

end


class StringCalculator

  def add(input)
    return 0 if input.empty?

    numbers = NumbersString.new(input).numbers
    raise_error_on_negative_number numbers
    numbers.reduce :+
  end



  private

  def raise_error_on_negative_number(numbers)
    numbers.each { |number| raise "Negatives not allowed: #{number}" if number < 0 }
  end

end


describe StringCalculator do

  describe "#add" do
    TESTCASES = {
      "" => 0,
      "1" => 1,
      "1,2" => 3,
      "1,2,3,4,5" => 15,
      "10,200,3000,4,5" => 3219,
      "1\n2,3" => 6,
      "//;\n2;3" => 5,
    }

    TESTCASES.each do |input, expected_output|
      it "should return #{expected_output} for '#{input}'" do
        expect(subject.add input).to eq expected_output
      end
    end
  end

  context "when called with a string containing a negative number" do
    it "should raise an exception" do
      expect { subject.add "-1,2" }.to raise_exception "Negatives not allowed: -1"
    end
  end

end
