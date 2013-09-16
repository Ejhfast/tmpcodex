require 'ruby_codex'
require 'set'
require 'pp'
require 'redis'

$redis = Redis.new
$redis.flushall

$stdout.sync = true

c = Codex.new(Array, Array)


def get_project(f)
  f.split("/")[1]
end

def ast_arr(ast)
  if ast.is_a? Parser::AST::Node
    [ast.type].concat ast.children.map { |x| ast_arr(x) }
  else
    ast
  end
end

bad_things = ["test","tests","spec"]
loc = 0
norm_store = Hash.new { |h,k| h[k] = Hash.new(0) }
graph_types = [:begin, :all, :send, :str, :block, :hash, :pair, :sym, :const, :args, :int, :array, :splat, :until, :if, :lvasgn, :def, :and, :casgn, :true, :irange, :float, :defs, :false, :arg, :self, :lvar, :restarg, :yield, :class, :optarg, :blockarg, :sclass, :module, :block_pass, :or_asgn, :zsuper, :ivasgn, :ivar, :nil, :return, :kwbegin, :rescue, :resbody, :or, :dstr, :next, :break, :case, :when, :op_asgn, :dsym, :erange, :regexp, :regopt, :masgn, :mlhs, :gvar, :cbase, :gvasgn, :defined?, :xstr, :nth_ref, :cvasgn, :cvar, :super, :alias, :ensure, :for, :match_with_lvasgn]
#[:send, :block, :if, :lvasgn, :def, :begin, :all]
timeline = []
store = Set.new

puts "loc,size,total_nodes,file"
files = Dir[ARGV[0]+"/**/*.rb"]#.select do |f|
  #f.split("/").all? { |x| !bad_things.include?(x) }
#end

file_count = 0
node_count = 0

files.each do |f|
  file_count += 1
  file_str = ""
  file_str = IO.read(f) rescue ""
  ast = Parser::CurrentRuby.parse(file_str) rescue nil
  begin
    c.tree_walk(ast) do |node|
      node_count += 1
      type = node.type
      nn = ASTNormalizer.new
      norm = nn.rewrite_ast(node) rescue nil
      norm_str = ast_arr(norm) rescue nil
      $redis.sadd("uniques",norm_str.to_s)
    end rescue nil
  rescue
  end
  lines = file_str.split("\n").count rescue 0
  loc += lines rescue nil
  #types = graph_types.map { |x| norm_store[x].select { |k,v| v > 1 }.size.to_s }.join(",") #/ norm_store.size
  #timeline.push(types)
  if file_count > 10
    puts "#{loc},#{$redis.smembers("uniques").size.to_s},#{node_count.to_s},#{f}"
    file_count = 0
  end
end
    
  
