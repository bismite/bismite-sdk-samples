
WID=ARGV[0]

def key(k,wait)
  system "xdotool key --window #{WID} --delay #{wait} #{k}"
  #sleep(wait/1000.0)
end

key "F1", 500
key "A", 500
key "B", 500
key "Right", 500
key "Up", 500
