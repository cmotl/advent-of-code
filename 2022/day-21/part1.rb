$a = File.open("sample_input.txt")
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
