#!/usr/bin/env ruby
require "fileutils"
require "colorize"

def run(cmd)
  t = Time.now
  puts "#{t.sec}.#{t.usec}: #{cmd}".green
  `#{cmd}`
end

def screenshot(name)
  pid = spawn "birun src/#{name}.rb"
  puts "pid: #{pid}"

  wid=""
  10.times do
    wid = `xdotool search --pid #{pid}`.strip
    break unless wid.empty?
    sleep 1
  end

  input_pid = nil
  unless wid.empty?
    puts "wid: #{wid}"
    FileUtils.mkdir_p "tmp/#{name}"
    input = "scripts/input/#{name}.rb"
    input_pid = spawn "ruby #{input} #{wid}" if File.exists? input
    30.times do |i|
      run "xwd -silent -id #{wid} | convert xwd:- tmp/#{name}/#{i}.png"
      sleep 0.1
    end
    spawn "apngasm tmp/#{name}.png tmp/#{name}/*.png"
  end

  Process.waitpid input_pid if input_pid
  Process.kill("HUP", pid)
end

FileUtils.mkdir_p "build"

%w(
 action
 cave_generator
 fiber
 global_update_callback
 keyboard
 label
 line_intersect
 line_of_sight
 menu
 particle
 rect_collide
 spotlight
 texture
 tile_map
 trace-cursor
).each{|name| screenshot name}
