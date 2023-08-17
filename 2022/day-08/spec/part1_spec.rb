require 'part1'

RSpec.describe "canary" do
  it "should fly" do
    input = "bvwbjplbgvbhsrlpgdmjqwftvncz"
    expect(Part1::start_of_packet(input)).to be 5
  end
end
