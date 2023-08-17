module Part2
  def self.max_calories(input)
    input
    .chunk_while{|x,y| x != 0 }
    .map(&:sum)
    .max(3)
    .sum
  end
end
