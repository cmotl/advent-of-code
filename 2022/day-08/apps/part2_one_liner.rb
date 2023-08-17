rows = File.open("original_input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map(&:chars)
 .to_a

columns = rows.transpose

scenic_score = 0

def scenic_score(current_tree_height, surrounding_trees)
    surrounding_trees
      .lazy
      .with_index
      .filter{|x, i| x >= current_tree_height }
      .map{|x,i| i+1 }
      .first or surrounding_trees.length
end

(1..rows.length-2).each{|row|
  (1..columns.length-2).each{|column|
    current_tree_height = rows[row][column]

    left_trees = rows[row][0..column-1].reverse
    right_trees = rows[row][column+1..-1]
    up_trees = columns[column][0..row-1].reverse
    down_trees = columns[column][row+1..-1]

    current_scenic_score = [left_trees, right_trees, up_trees, down_trees].map{|x| scenic_score(current_tree_height, x) }.reduce(&:*)

    scenic_score = [scenic_score, current_scenic_score].max
  }
}

p scenic_score
