projects = IO.read(ARGV[0]).split("\n")

sample = projects.sample(ARGV[1].to_i)

sample.each do |p|
	`mv #{ARGV[2]}/#{p} #{ARGV[3]}`
end