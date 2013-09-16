require 'parser/current'
require 'unparser'
require 'ast'
require 'pp'
require 'mongoid'
require 'set'
require 'ruby_codex'
load 'file_process.rb'


Mongoid.load!("local.yaml", :development)

class ASTNodes; include Mongoid::Document; end
class ASTStats; include Mongoid::Document; end

bad_things = ["test","tests","spec"]
projects_list = Set.new

ana = Codex.new(ASTNodes, ASTStats)

processor = FileProcess.new(ARGV[0], 
  lambda { |name| name.split("/")[1] },
  lambda { |name| name.split("/").all? { |i| !bad_things.include?(i) } }
  )

data_arr = []
rangee = (0..100).to_a

processor.process do |f,project,loc,file_str|
  projects_list.add(project)
  ast = Parser::CurrentRuby.parse(file_str) rescue nil
  ana.tree_walk(ast) do |node|
    ana.add_ast(node, f, project) #{ |k,v| pp [k,v] if k[:type] == "func_chain" && k[:f1] == "=" }
    # ana.block.add_ast(node,f,project) { |k,v| pp [k,v] }
    # ana.func.add_ast(node,f,project) #{ |k,v| pp [k,v] }
    # ana.cond.add_ast(node,f,project) #{ |k,v| pp [k,v] }
    # ana.ident.add_ast(node,f,project) #{ |k,v| pp [k,v] }
    # ana.func_chain.add_ast(node,f,project) #{ |k,v| pp [k,v] }
  end
  #data_arr.push({:loc => loc, :size => ana.index_size {|h| h.select {|k,v| v.size > (projects_list.size.to_f * 0.02) } }}) if rangee.sample <= 99
  puts loc
end

#puts "Data"

ASTNodes.delete_all
ASTStats.delete_all
ana.save_all!

#pp data_arr.sample(100)

# ana.block.save!
# ana.func.save!
# ana.ident.save!
# ana.func_chain.save!
# ana.cond.save!