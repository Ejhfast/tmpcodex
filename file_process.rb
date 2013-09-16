class FileProcess
  def initialize(dir, name, keep)
    @name = name
    @keep = keep
    @loc = 0
    @files = Dir["#{dir}/**/*.rb"]#Dir["#{ARGV[0]}/**/*.rb"]
  end

  def no_tests(f)
    tokens = f.split("/")
    result = true
    ["test","spec","tests"].each do |x|
      result &&= !tokens.include?(x)
    end
    result
  end
  
  def get_project_name(str)
    # for rvm
    # str.split("/")[7].split("-")[0]
    # for local
    # str.split("/")[1]
    @name.call(str)
  end

  def process
    @files.select { |f| @keep.call(f) }.each do |f|
      project = get_project_name(f)
      if no_tests(f)
        file_str = IO.read(f) rescue nil
        if file_str
          @loc += file_str.lines.count
          yield f, project, @loc, file_str
        end
      end
    end
  end
end