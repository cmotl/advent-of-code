lookup = { "A" => :rock, "B" => :paper, "C" => :scissors, "X" => :lose, "Y" => :draw, "Z" => :win }
outcomes = {
  [:rock,:draw] => :rock, 
  [:rock,:lose] => :scissors, 
  [:rock,:win] => :paper,
  [:paper,:win] => :scissors, 
  [:paper,:draw] => :paper, 
  [:paper,:lose] => :rock,
  [:scissors,:lose] => :paper, 
  [:scissors,:win] => :rock, 
  [:scissors,:draw] => :scissors
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
 .map{|x| scores[outcomes[x]] + scores[x[1]] }
 .reduce(:+)

puts(score)
