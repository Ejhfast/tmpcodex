
file_str = IO.read(ARGV[0]).split("\n")

puts file_str.first
puts file_str.sample(ARGV[1].to_i).sort_by { |x| x.split(",")[0].to_i }