
def create_world
  Bi.init 480,320,30,"Texture"

  # texture image
  img = Bi::TextureImage.new "assets/face01.png", false, 0
  # texture
  tex = Bi::Texture.new img,0,0,img.w,img.h
  # sprite
  face = Bi::Sprite.new tex
  face.texture = tex
  face.set_position 240,160
  face.anchor = :center

  # layer
  layer = Bi::Layer.new
  layer.root = face
  Bi::add_layer layer
end

create_world
Bi::start_run_loop
