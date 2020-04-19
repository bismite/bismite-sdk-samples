
WID=ARGV[0]

def click(x,y)
  `xdotool mousemove --window #{WID} #{x} #{y} click 1`
end

sleep 0.5
click 240,160
sleep 0.5
click 240,190
sleep 0.5
click 240,210
