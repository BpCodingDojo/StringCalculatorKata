require 'rspec'

class Calculator

  def add(*input)
    return 0 if input.empty?

    parsed_input = parse_input(input)
    validate_numbers parsed_input


    result = calculate_sum(parsed_input)


    result
  end

  private

  def calculate_sum(parsed_input)
    parsed_input.inject(0) do |sum, n|
      number = n.to_i
      sum += number unless number > 1000

      sum
    end
  end

  def validate_numbers(parsed_input)
    negatives = []
    parsed_input.each do |n|
      number = n.to_i

      negatives << number if number < 0
    end
    raise ArgumentError.new("Negatives not allowed: #{negatives.join(',')}") unless negatives.empty?
  end


  def parse_input(input)
    delimiter = ','
    matchdata = input[0].match %r{//(?<delimiter>.)\n(?<numbers>.*)}

    if matchdata
      delimiter = matchdata[:delimiter]
      input[0] = matchdata[:numbers]
    end
    input.join(delimiter).split(/[#{delimiter}\n]/)
  end
end

describe Calculator do

  describe "#add" do

    it "shoduld return  0 for an empty string" do
      expect(subject.add("")).to eq 0
    end

    {
        "1" => 1,
        "2" => 2,
        "1,0" => 1,
        "1,2" => 3,
        "1\n2" => 3,
    }.each do |input, output|
      it "should return #{input} for '#{output}'" do
        expect(subject.add(input)).to eq output
      end
    end

    it "should return 3 for arguments '1' and '2'" do
      expect(subject.add("1", "2")).to eq 3
    end

    it "should handle optional delimiter" do
      expect(subject.add "//|\n1|2").to eq 3
    end

    {
        "-1,2" => "-1",
        "-1,-2" => "-1,-2"
    }.each do |input, output|

      it "should throw exception for negative numbers" do
        expect {
          subject.add(input)
        }.to raise_error ArgumentError, "Negatives not allowed: #{output}"
      end


    end

    it "should ignore numbers greater than 1000" do
      expect(subject.add("1001", "2")).to eq 2
    end


    it "should handle optional delimiter of any length" do
      expect(subject.add "//[***]\n1***2").to eq 3
    end


  end
end