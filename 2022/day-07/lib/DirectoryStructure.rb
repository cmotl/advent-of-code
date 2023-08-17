require 'directory_structure'

def new_command?(x,y)
  (x.start_with? '$' and not y.start_with? '$') or (not y.start_with? '$' and not x.start_with? '$')
end

def parse_command(x)
  _,a,b = x.split(' ')
  {:executable => a, :arguments => b}
end

def directory?(x)
  x.start_with? "dir"
end

def parse_directory(x)
  x.split(' ').drop(1).take(1).first
end

def parse_file(x)
  size, name = x.split(' ')
  {:name => name, :size => size.to_i}
end

def parse_responses(responses)
  contents = {:dirs =>[], :files => []}
  responses.reduce(contents){|agg, x| directory?(x) ?  agg[:dirs] << parse_directory(x) : agg[:files] << parse_file(x); agg }
end

def new_directory(name)
  {:name => name, :files => [], :directories => {}}
end

def parse_instrustions(input)
 input
 .chunk_while{|x,y| new_command? x,y }
 .map{|head, *tail| {:command => parse_command(head), :result => parse_responses(tail) } }
end

class DirectoryStructure

  def initialize()
    @root = new_directory('/')
    @current_directory = [@root]
  end

  def directory_exists?(name)
    @current_directory[-1][:directories].key? name
  end

  def change_directory(name)
    case name
    when '..'
      @current_directory.pop
    when '/'
      @current_directory = [@root]
    else
      if not directory_exists? name 
          @current_directory[-1][:directories][name] = new_directory(name)
      end
      @current_directory << @current_directory[-1][:directories][name]
    end
  end

  def set_contents(result)
    @current_directory[-1][:files] += result[:files]
    result[:dirs].each{|d| @current_directory[-1][:directories][d] = new_directory(d) }
  end

  def apply_command(command)
    case command[:command][:executable]
    when "cd"
      change_directory(command[:command][:arguments])
    when "ls"
      set_contents(command[:result])
    end
  end

  def directory_tree
    [@root]
  end

  def all_directories(dir = @root)
    [dir, dir[:directories].map{|k, v| all_directories(v) }.flatten()].flatten()
  end
end

def directory_size(dir)
  dir[:files].map{|x| x[:size] }.sum + (dir[:directories].map{|k,v| directory_size(v) }.sum)
end


input = File.open("input.txt")
 .each_line
 .lazy

p parse_instrustions(input)
 .reduce(DirectoryStructure.new){|agg, x| agg.apply_command(x); agg }
 .all_directories
 .map{|x| directory_size(x) }
 .filter{|x| 70000000 - 44359867 + x > 30000000  }
 .sort
 .first
