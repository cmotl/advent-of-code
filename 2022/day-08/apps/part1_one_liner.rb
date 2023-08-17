rows = File.open("original_input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map(&:chars)
 .to_a

columns = rows.transpose

def exterior_tree_count(rows)
  4*(rows.length-1)
end

visible_trees = exterior_tree_count(rows)

(1..rows.length-2).each{|row|
  (1..columns.length-2).each{|column|
    current_tree_height = rows[row][column]

    if rows[row][0..column-1].all? {|x| current_tree_height > x } or rows[row][column+1..-1].all? {|x| current_tree_height > x } then
      visible_trees += 1
    elsif columns[column][0..row-1].all? {|x| current_tree_height > x } or columns[column][row+1..-1].all? {|x| current_tree_height > x } then
      visible_trees += 1
    end
  }
}

p visible_trees
