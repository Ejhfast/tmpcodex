require 'ruby_codex'
require 'rethinkdb'
require 'set'
require 'pp'

include RethinkDB::Shortcuts

r.connect.repl

c = Codex.new(Array, Array)

def get_project(f)
  f.split("/")[1]
end

r.table_drop('snippets').run rescue nil
r.table_create('snippets').run rescue nil

bad_things = ["test","tests","spec"]

files = Dir[ARGV[0]+"/**/*.rb"].select do |f|
  f.split("/").all? { |x| !bad_things.include?(x) }
end

loc = 0

files.each do |f|
  file_str = IO.read(f) rescue ""
  jsons = []
  ast = Parser::CurrentRuby.parse(file_str) rescue nil
  begin
    c.tree_walk(ast) do |node|
      type = node.type
        nn = ASTNormalizer.new
        norm = nn.rewrite_ast(node) rescue nil
        jsons.push({
            :type => type.to_s,
            #:orig_code => Unparser.unparse(ast),
            :norm_code => (Unparser.unparse(norm) rescue nil),
            :project => get_project(f),
            :line => (node.loc.line rescue nil),
            :file => f,
            :count => 1,
            :info => nn.pretty_complexity.map { |k,v| v }.reduce(:+),
            :func_info => nn.pretty_complexity[:send] || 0
          })
    end #rescue nil
    r.table('snippets').insert(jsons).run()
  rescue
  end
  lines = file_str.split("\n").count rescue 0
  loc += lines rescue nil
  puts (loc.to_s + "," + f)
end
    
  
