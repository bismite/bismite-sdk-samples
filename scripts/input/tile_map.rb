
WID=ARGV[0]

def key(k,wait)
  system "xdotool key --window #{WID} #{k}"
  sleep wait
end

key "Up", 0.2
key "Right", 0.2
key "Up", 0.2
key "Right", 0.2
key "Up", 0.2
key "Right", 0.2
key "Up", 0.2
key "Right", 0.2
