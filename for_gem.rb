# array
var0 = if var1.last.is_a?(Hash) #annot
  var1.pop
else
  {}
end

# Float
var0.to_f / var1.to_f

# Hash
var0.keys.map do |var1|
  var1.to_s
end

#Enumerable
var0.length == var1.length

#File
File.expand_path(File.join(File.dirname("str0"), "str1"))

var0.sort do |var1, var2|
  var1[0] <=> var2[0]
end

#Object
if var0.const_defined?(var1)
  var0.const_get(var1)
else
  var0.const_missing(var1)
end

#Object
var0.to_s.downcase.to_sym

#Enumerable
var0.each do |var1|
  var2 << var1.to_s
end

#Enumerale
0.upto(var0.size - 1)

# Hash
if var0.has_key?(var1)
  var0[var1].push(var2)
else
  var0[var1] = [var2]
end

# String
var0.split(/str0/).map do |var1|
  var1.capitalize
end.join("str0")

# Hash
var0.keys.collect do |var1|
  var1.to_s
end.sort

# File
((File.exist?(var0)) && (!File.directory?(var0)))

# Hash
Hash.new do |var2, var3|
  var2[var3] = []
end

# Hash
Hash.new do |var2, var3|
  var2[var3] = {}
end

# Object
self.class.name.split("str0")

# Hash
var0[var1] ||= []
var0[var1] << var2

var0.collect do |var1|
  var1.to_s
end.join("str0")

# Array
if var0.first.empty?
  var0.shift
end

# Hash
var0 = Hash.new
var1.each do |var2, var3|
  unless String === var2
    raise(InvalidHashTupleKey)
  end
  var0[var2] = var3
end

# Enumerable
var0.to_s.split("str0").last # annot

# Hash
((var0[:sym0]) || (var0["str0"])) # annot

# IO
if ((var0) && (!var0.closed?)) # annot
  var0.close
end




