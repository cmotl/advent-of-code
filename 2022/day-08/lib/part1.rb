module Part1
  def self.start_of_packet(input)
    input.chars
      .each_cons(4)
      .with_index
      .filter{|x, i| x.uniq.length == 4 }
      .map{|x, i| i + 4}
      .first
  end
end
