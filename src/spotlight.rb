require "lib/stats"

Bi::init 480,320, title:__FILE__
Bi::Archive.new("assets.dat",0x5).load do |assets|

  # 1st layer (shadowed sky)
  sky_texture = assets.texture "assets/sky.png"
  sky = sky_texture.to_sprite
  shadow = Bi::Node.new
  shadow.set_size Bi.w,Bi.h
  shadow.set_color 0,0,0,128
  sky.add shadow
  layer1 = Bi::Layer.new
  layer1.root = sky
  layer1.set_texture 0, sky_texture

  # 2nd layer (spotlight)
  spotlight_texture = assets.texture "assets/circle256.png"
  spotlight = spotlight_texture.to_sprite
  spotlight.anchor = :center
  spotlight.set_position Bi.w/2, Bi.h/2
  layer2 = Bi::Layer.new
  layer2.root = spotlight
  layer2.set_texture 0, spotlight_texture
  layer2.blend_src = Bi::Layer::GL_DST_COLOR
  layer2.blend_dst = Bi::Layer::GL_ONE

  # spin
  spotlight.on_update{|n,delta| n.angle+=1 }

  Bi::add_layer layer1
  Bi::add_layer layer2

  stats assets
end

Bi::start_run_loop
