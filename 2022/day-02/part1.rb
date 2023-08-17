lookup = { "A" => :rock, "B" => :paper, "C" => :scissors, "X" => :rock, "Y" => :paper, "Z" => :scissors }
outcomes = {
  [:rock,:rock] => :draw, 
  [:rock,:paper] => :lose, 
  [:rock,:scissors] => :win,
  [:paper,:rock] => :win, 
  [:paper,:paper] => :draw, 
  [:paper,:scissors] => :lose,
  [:scissors,:rock] => :lose, 
  [:scissors,:paper] => :win, 
  [:scissors,:scissors] => :draw
}
scores = {
  :draw => 3,
  :win => 6,
  :lose => 0,
  :rock => 1,
  :paper => 2,
  :scissors => 3
}
score = File.open("input.txt")
 .each_line
 .lazy
 .map{|x| x.strip.split(/ /).map{|y| lookup[y]} }
 .map{|x| scores[outcomes[x.reverse]] + scores[x[1]] }
 .reduce(:+)

puts(score)
