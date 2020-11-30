require "lib/stats"

Bi.init 480,320,title:__FILE__,highdpi:true

Bi::Archive.new("assets.dat",0x5,true).load do |assets|
  stats assets

  # layer
  layer = Bi::Layer.new
  layer.root = Bi::Node.new
  layer.root.set_color 0x33,0,0,0xff
  layer.root.set_size Bi.w,Bi.h
  Bi::add_layer layer

  # texture
  texture = assets.texture("assets/face01.png")
  face = texture.to_sprite
  face.set_position Bi.w/2,Bi.h/2
  face.anchor = :center
  layer.set_texture 0, texture
  layer.root.add face
end

Bi::start_run_loop
