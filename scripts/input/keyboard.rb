
WID=ARGV[0]

def key(k,wait)
  system "xdotool keydown --window #{WID} #{k}"
  sleep wait
end

key "F1", 0.5
key "A", 0.5
key "B", 0.5
key "Right", 0.5
key "Up", 0.5
key "Down", 0.5
