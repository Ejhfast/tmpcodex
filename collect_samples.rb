require 'rethinkdb'
require 'pp'
require 'json'

include RethinkDB::Shortcuts


r.connect().repl

  r.table_drop("snippet_stats").run rescue nil
	r.table_create("snippet_stats").run rescue nil

	r.table("snippet_stats").insert(r.table("snippets")
     .filter { |x| x[:info].gt(2) }
     .filter { |x| x[:func_info].gt(2) }
     .grouped_map_reduce(
       lambda { |x| x[:norm_code] },
       lambda { |x| x.merge({:projects => [x[:project]]}) },
       {:projects => [], :count => 0},
       lambda do |acc, el| {
          :norm_code => el[:norm_code],
          :type => el[:type],
          :info => el[:info],
          :func_info => el[:func_info],
          :count => acc[:count].add(el[:count]),
          :projects => acc[:projects].set_union(el[:projects]) }
       end)
     .map { |x| x[:reduction].merge({ :project_count => x[:reduction][:projects].count }) }).run

   #   .filter(lambda do |el|
   #  	el[:project_count].gt(3)
 	 # end)
 	# .filter(lambda { |el| el[:info].lt(15) })
 	# .filter(lambda { |el| el[:send].gt(2) })
 	# .order_by(r.desc("project_count"))
 	# .count().run()

