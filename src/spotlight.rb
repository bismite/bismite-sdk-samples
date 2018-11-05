
def create_world
  Bi.init 640,480,30,"spotlight"

  # background
  img = Bi::TextureImage.new "assets/sky.png", false, 0
  bg = Bi::Sprite.new Bi::Texture.new img,0,0,img.w,img.h
  # shadow
  shadow = Bi::Node.new
  shadow.set_bound 0,0,640,480
  shadow.set_color 0,0,0,128
  bg.add shadow

  # layer
  layer = Bi::Layer.new
  layer.root = bg
  Bi::add_layer layer

  # sportlight
  img = Bi::TextureImage.new "assets/circle256.png", false, 1
  spotlight = Bi::Sprite.new Bi::Texture.new img,0,0,img.w,img.h
  spotlight.anchor = :center
  spotlight.set_position Bi.w/2, Bi.h/2
  # spotlight layer
  layer = Bi::Layer.new
  layer.root = spotlight
  Bi::add_layer layer
  # blending
  layer.blend_src = Bi::Layer::GL_DST_COLOR
  layer.blend_dst = Bi::Layer::GL_ONE

  # spin
  spotlight.on_update{|n,delta| n.angle+=1 }
end

create_world
Bi::start_run_loop
