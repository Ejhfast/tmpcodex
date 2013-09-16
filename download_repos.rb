require 'github_api'
require 'pp'

repos = []

github = Github.new login: "Ejhfast:dragon2250"
(0..15).each do |page|
  search = github.search.repos keyword: 'ruby', language: 'ruby', sort: 'stars', start_page: page
  search[:repositories].each do |r|
    puts "#{r[:url]},#{r[:watchers]}" if r[:watchers] > 50
    #puts r[:name]
    # puts r[:description]
    # puts r[:watchers]
  end
end

#puts repos.uniq
