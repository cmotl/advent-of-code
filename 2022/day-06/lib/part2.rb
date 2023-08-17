module Part2
  def self.start_of_message(input)
    input.chars
      .each_cons(14)
      .with_index
      .filter{|x, i| x.uniq.length == 14 }
      .map{|x, i| i + 14}
      .first
  end
end
