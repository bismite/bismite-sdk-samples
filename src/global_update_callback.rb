require "lib/stats"

Bi.init 480,320, title:__FILE__
Bi::Archive.new("assets.dat",0x5).load do |assets|
  texture = assets.texture "assets/face01.png"

  face = texture.to_sprite
  face.set_position Bi.w/2, Bi.h/2
  face.anchor = :center

  layer = Bi::Layer.new
  layer.root = face
  layer.set_texture 0, texture
  Bi::add_layer layer

  Bi.add_update_callback{|delta| face.angle += 1 }
  stats assets
end

Bi::start_run_loop
