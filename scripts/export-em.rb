#!/usr/bin/env ruby
require "colorize"

def run(cmd)
  t = Time.now
  puts "#{t.sec}.#{t.usec}: #{cmd}".green
  `#{cmd}`
end

Dir.glob("src/*.rb"){|f|
  run "biexport emscripten #{f} assets.dat tmp/"
}
