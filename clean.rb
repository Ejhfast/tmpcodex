

file = IO.read(ARGV[0]).split("\n").map { |x| x.split(",").take(ARGV[1].to_i).join(",") }

puts file