#!/usr/bin/env ruby

list = Dir.glob("src/*.rb").sort{|a,b| a<=>b }

list.each{|f|
  name = File.basename f,".rb"
  puts "<li><a href=\"#{name}\" target=\"sample\">#{name}</a></li>"
}

list.each{|f|
  name = File.basename f,".rb"
  puts "| #{name} | ![#{name}.png](images/#{name}.png) |"
}

list.each{|f|
  name = File.basename f,".rb"
  puts "<img src=\"images/#{name}.png\" width=\"240\" height=\"160\">"
}
