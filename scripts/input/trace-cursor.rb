
WID=ARGV[0]
puts "wid: #{WID}"

def move(x,y,wait)
  system "xdotool mousemove --window #{WID} #{x} #{y}"
  sleep wait
end

100.times do |i|
  t = i / 10.0
  x = 100 + 50.0 * Math.cos(t)
  y = 100 + 50.0 * Math.sin(t)
  move x,y, 0.01
end
