module Part1
  def self.max_calories(input)
    input
    .chunk_while{|x,y| x != 0 }
    .map(&:sum)
    .max or 0
  end
end
