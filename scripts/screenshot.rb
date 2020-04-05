#!/usr/bin/env ruby
require "fileutils"
require "colorize"

def run(cmd)
  t = Time.now
  puts "#{t.sec}.#{t.usec}: #{cmd}".green
  `#{cmd}`
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

  input_pid = nil
  unless wid.empty?
    puts "wid: #{wid}"
    FileUtils.mkdir_p "tmp/#{name}"
    input_pid = Process.fork do
      input = "scripts/input/#{name}.rb"
      exec "ruby #{input} #{wid}" if File.exists? input
    end
    20.times do |i|
      run "xwd -silent -id #{wid} | convert xwd:- tmp/#{name}/#{i}.png"
      sleep 0.1
    end
    run "apngasm tmp/#{name}.png tmp/#{name}/*.png"
  end

  Process.kill("HUP", input_pid) if input_pid
  Process.kill("HUP", pid)
end

FileUtils.mkdir_p "build"
%w(
 action
 cave_generator
 dungeon
 keyboard
 fiber
 global_update_callback
 label
 menu
 particle
 spotlight
 texture
 trace-cursor
).each{|name| screenshot name}
