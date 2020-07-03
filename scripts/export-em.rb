#!/usr/bin/env ruby
require "colorize"

def run(cmd)
  t = Time.now
  puts "#{t.sec}.#{t.usec}: #{cmd}".green
  `#{cmd}`
end

Dir.glob("src/*.rb"){|f|
  run "biexport wasm #{f} assets.dat tmp/"
}

list = Dir.glob("src/*.rb").map{|f|
  File.basename f,".rb"
}.sort.map{|name|
  "<li><a href=\"#{name}\" target=\"sample\">#{name}</a></li>"
}.join("\n")

index_html=<<EOS
<head>
  <style>
    iframe{
      border: 0;
      padding:0;
      margin:0
    }
    .sample {
      text-align:center;
    }
  </style>
</head>

<body>

<ul>
#{list}
</ul>

<div class="sample"><iframe id="sample" name="sample" src="keyboard" width=480 height=320></iframe></div>
EOS

File.write "tmp/index.html", index_html
