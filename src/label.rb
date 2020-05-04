require "lib/stats"

Bi::init 480,320, title:__FILE__

Bi::Archive.new("assets.dat",0x5).load do |assets|

  root = Bi::Node.new
  root.set_size Bi.w, Bi.h
  root.set_color 0x33,0,0,0xff

  texture = assets.texture "assets/gohufont.png", false
  font = Bi::Font.new texture, assets.read("assets/gohufont-bold-14-0.0.dat")

  label = Bi::Label.new font
  label.set_position Bi.w/2, Bi.h/2
  label.set_color 0xff,0xff,0xff,0x33
  label.anchor = :center
  label.scale_x = label.scale_y = 3.0
  label.add_timer(500,-1){|n,now,timer|
    label.set_text ["Label","ABCDEF","(@o@)","('_`)","(^_^)"].sample
  }
  root.add label

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture 0, texture
  Bi::add_layer layer

  stats assets
end

Bi::start_run_loop
