require 'ruby_codex'
require 'rethinkdb'
require 'set'
require 'pp'

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

#puts "loc,#{graph_types.map { |x| x.to_s }.join(",") }"
puts  "loc,send,const"
files = Dir[ARGV[0]+"/**/*.rb"]#.select do |f|
  #f.split("/").all? { |x| !bad_things.include?(x) }
#end
files.each do |f|
  file_str = ""
  file_str = IO.read(f) rescue ""
  ast = Parser::CurrentRuby.parse(file_str) rescue nil
  begin
    c.tree_walk(ast) do |node|
      type = node.type
      if type == :send
        norm_store[:send][node.children[1]] += 1
      elsif type == :const
        norm_store[:const][node.children[1]] += 1
      end
      # nn = ASTNormalizer.new
      # norm = nn.rewrite_ast(node) rescue nil
      # norm_str = Unparser.unparse(norm) rescue nil
      # norm_store[type][norm_str] += 1
      # norm_store[:all][norm_str] += 1
    end rescue nil
  rescue
  end
  lines = file_str.split("\n").count rescue 0
  loc += lines rescue nil
  #types = graph_types.map { |x| norm_store[x].select { |k,v| v > 1 }.size.to_s }.join(",") #/ norm_store.size
  #timeline.push(types)
  puts "#{loc},#{norm_store[:send].size.to_s},#{norm_store[:const].size.to_s}"
end
    
  
