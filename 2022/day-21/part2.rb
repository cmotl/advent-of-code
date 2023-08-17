$a = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| ( x.match(/(\w+): (\d+)/) or x.match(/(\w+): (\w+) ([+|\-|*|\/]) (\w+)/) ).to_a.drop(1) }
 .reduce({}){|agg, x| 
    if x.length == 2
      monkey,number = x
      agg[monkey] = number.to_i
    else
      monkey,left,operation,right = x
      agg[monkey] = {'left'=> left, 'operation'=>operation, 'right' => right }
    end
    agg
 }

#$a = {'hello' => 1, 'goodbye' => 2, 'root' => {'operation' => :+, 'left' => 'hello', 'right' => 'goodbye'}}

def method_missing name, *args, &block
  value = $a[name.to_s]
  case value
  when 'root'
    p "left #{public_send(value['left'])}"
    p "right #{ public_send(value['right'])}"
  when Fixnum
    return value
  when Hash
    return (public_send(value['left'])).public_send(value['operation'], public_send(value['right']))
  end
end

#p hello
#p goodbye
p root

def contains_humn(tree)
  if tree == 'humn'
    return true
  end

  t = $a[tree]
  case t 
  when Hash
    if t['left'] == 'humn' or t['right'] == 'humn'
      return true
    else
      return (contains_humn(t['left']) or contains_humn(t['right']))
    end
  end
  return false
end

print "left contains 'humn': #{contains_humn($a['root']['left'])}"; puts
print "right contains 'humn': #{contains_humn($a['root']['right'])}"; puts

def inverse_operation(operation)
  if operation == '+'
    return '-'
  elsif operation == '-'
    return '+'
  elsif operation == '*'
    return '/'
  elsif operation == '/'
    return '*'
  end
end


#target_branch, working_branch = 
#  if contains_humn($a['root']['left']) 
#    ['right', 'left']
#  else 
#    ['right', 'left']
#  end

def branches(node)
  if contains_humn($a[node]['left']) 
    puts 'left contains humn'
    return ['right', 'left']
  else 
    return ['left', 'right']
  end
end

target_branch, humn_branch = branches('root')

target_value = public_send($a['root'][target_branch])

print target_value; puts

def find_humn_value(node, target_value)

  print(node + " " + target_value.to_s); puts

  if node == 'humn'
    return target_value
  end

  if $a[node].is_a? Integer
    return $a[node]
  end

  target_branch, humn_branch = branches(node)
  target_branch_value = public_send($a[node][target_branch])
  print("target branch value #{target_branch_value}"); puts
  
  operation = $a[node]['operation']
  puts $a[node]['left'], $a[node]['operation'], $a[node]['right']
  puts humn_branch

  if humn_branch == 'left'
    if  operation == '+'
      puts('+')
      new_target_value = target_value.public_send('-',target_branch_value)
    elsif operation == '-'
      puts('X')
      puts($a[node])
      puts(target_branch)
      target_branch_value *= -1
      new_target_value = target_value.public_send('-',target_branch_value)
    elsif operation == '*'
      new_target_value = target_value.public_send('/',target_branch_value)
    elsif operation == '/'
      new_target_value = target_branch_value.public_send('*',target_value)
    end
  else
#    if operation == '-' or operation == '+'
#      new_target_value = target_value.public_send('-',target_branch_value)
    if  operation == '+'
      puts('+')
      new_target_value = target_value.public_send('-',target_branch_value)
    elsif operation == '-'
      puts('X')
      puts($a[node])
      puts(target_branch)
      target_branch_value *= -1
      target_value *= -1
      new_target_value = target_value.public_send('-',target_branch_value)
    elsif operation == '*'
      puts('*')
      new_target_value = target_value.public_send('/',target_branch_value)
    elsif operation == '/'
      puts('/')
      new_target_value = target_branch_value.public_send('/',target_value)
    end
  end
  
  print("new target value #{new_target_value}"); puts
  return find_humn_value($a[node][humn_branch], new_target_value)
end

#print "left #{public_send($a['root']['left'])}"; puts
#print "right #{public_send($a['root']['right'])}"; puts

humn_value = find_humn_value($a['root'][humn_branch], target_value)

p humn_value

$a['humn'] = humn_value

p public_send($a['root']['left'])
p public_send($a['root']['right'])
