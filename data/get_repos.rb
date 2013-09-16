repos = IO.read(ARGV[0]).split("\n").map { |x| x.split(",")[0] }

repos.each do |repo|
	`git clone #{repo}`
end