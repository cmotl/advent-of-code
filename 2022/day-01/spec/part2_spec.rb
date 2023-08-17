require 'part2'

RSpec.describe "calorie counting" do
  it "can find max of zero from no calories" do
    input = []
    expect(Part2::max_calories(input)).to eq 0
  end

  it "can find max of single calories from single elf" do
    input = [1000]
    expect(Part2::max_calories(input)).to eq 1000
  end

  it "can find max of single calories from two elves" do
    input = [1000,0,2000]
    expect(Part2::max_calories(input)).to eq 3000
  end

  it "can find max of multiple calories from single elf" do
    input = [1000, 2000, 3000]
    expect(Part2::max_calories(input)).to eq 6000
  end

  it "can find max of multiple calories from multiple elves" do
    input = [1000, 2000, 3000, 0, 4000, 0, 5000, 6000, 0, 7000, 8000, 9000, 0, 10000]
    expect(Part2::max_calories(input)).to eq 45000
  end
end
