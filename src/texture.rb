require "lib/stats"

Bi.init 480,320,title:__FILE__

# layer
layer = Bi::Layer.new
layer.root = Bi::Node.new
Bi::add_layer layer

Bi::Archive.new("assets.dat",0x5,true).load do |assets|
  # texture
  texture = assets.texture("assets/face01.png")
  face = texture.to_sprite
  face.set_position Bi.w/2,Bi.h/2
  face.anchor = :center
  layer.set_texture 0, texture
  layer.root.add face
  stats assets
end

Bi::start_run_loop
