#!/usr/bin/env ruby
require "fileutils"
require "colorize"

def run(cmd)
  t = Time.now
  puts "#{t.sec}.#{t.usec}: #{cmd}".green
  `#{cmd}`
end

def input(name,wid)
  return unless File.exists? "scripts/input/#{name}.input"
  File.read("#{name}.input").each_line{|l|
    run "xdotool key --window #{wid} --delay #{l}"
  }
end

def screenshot(name)
  pid = Process.fork do
    exec "mruby src/#{name}.rb"
  end

  puts "pid: #{pid}"

  wid=""
  10.times do
    wid = `xdotool search --pid #{pid}`.strip
    break unless wid.empty?
    sleep 1
  end

  unless wid.empty?
    puts "wid: #{wid}"
    FileUtils.mkdir_p "tmp/#{name}"
    Process.fork{ input name,wid }
    20.times do |i|
      run "xwd -silent -id #{wid} | convert xwd:- tmp/#{name}/#{i}.png"
      sleep 0.1
    end
    run "apngasm tmp/#{name}.png tmp/#{name}/*.png"
  end

  Process.kill("HUP", pid)
end

FileUtils.mkdir_p "build"
%w(
 action
 cave_generator
 dungeon
 event-keyboard
 fiber
 global_update_callback
 label
 menu
 particle
 spotlight
 texture
 trace-cursor
).each{|name| screenshot name}
