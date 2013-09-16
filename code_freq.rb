require 'set'
require 'rubyvis'

store = Set.new
growth = []
count = 0

csv = IO.read(ARGV[0]).split("\n").map{ |x| x.split(",") }
titles = csv.first
data = csv.drop(1)

def get_rows(names, titles, data)
  out = []
  names.each do |name|
    idx = titles.index(name)
    raise "die" unless idx
    out.push(data.map { |x| x[idx].to_i })
  end
  out[0].zip(out[1])
end

nodes = titles.drop(1)
lines = []

nodes.each do |n|
  send_loc = get_rows(["loc",n], titles, data).sample(100)
  max_x = send_loc.map { |x| x[0] }.max
  max_y = send_loc.map { |x| x[1] }.max
  scale_x = 500.0 / max_x.to_f
  scale_y = 300.0 / max_y.to_f
  send_loc = send_loc.map { |x| [x[0] * scale_x, x[1] * scale_y]}
  lines.push({:text => n, :data => send_loc})
end

# pp [scale_x, scale_y]


#pp send_loc

#$growth = growth.map{|x| [x[0], x[1].to_f / count.to_f]}.select{|x| x[0] % 1000 == 0}

#pp $growth

light_blue = "#8FDFFF"
dark_blue = "#48A3C7"

colors = 

freq = Rubyvis.Panel.new do 
    width 2500
    height 500*lines.size
    lines.each.with_index do |l,i|
      label do
        font("bold 12px sans-serif")
        text l[:text]
        bottom { |d| 150+(i*500) }
        left 100
      end
      dot do
        data l[:data]
        shape_radius 1
        fill_style "black"
        bottom { |d| (i*500)+d[1] }
        left { |d| d[0] }
      end
    end

    # label do
    #   data Rubyvis.range(0,1,0.1).select{|x| x % 0.1 == 0}
    #   text {|d| d}
    #   fill_style "black"
    #   bottom {|d| 20 + d * 500.0}
    #   left 110
    # end
    # bar do
    #   data $growth
    #   width 3
    #   height {|d| 500.0 * d[1]}
    #   bottom(20)
    #   fill_style {|d| true || d[0] <= 1 ? light_blue : dark_blue}
    #   left {130 + index * 5}
    # end
  end

#pp $info_d.keys.first(20)
#freq.add(Rubyvis::Scale::Quantitative).ticks(count / 5)
# freq.add(pv.Label).bottom(0).left(130).text("frequency of occurrence")
# freq.add(Rubyvis::Label).bottom(170).left(70).text("# patterns").text_angle(-1*0.5*3.1415)
#freq.add(Rubyvis::Label).top(30).left(370).add(pv.Label).font("bold 12px sans-serif").text("Send")

freq.render
puts freq.to_svg