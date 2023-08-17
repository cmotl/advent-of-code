require 'part2'

RSpec.describe "canary" do
  it "should fly" do
    input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    expect(Part2::start_of_message(input)).to be 19
  end
end
