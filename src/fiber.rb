
class Fiber
  def self.sleep(sec)
    t = Time.now
    self.yield while Time.now - t < sec
  end
end

def create_world
  Bi.init 480,320, title:"Fiber"

  root = Bi::Node.new
  root.set_size Bi.w, Bi.h
  root.set_color 0x33,0,0,0xff

  # create sprite
  img = Bi::TextureImage.new "assets/face01.png", false
  tex = Bi::Texture.new img,0,0,img.w,img.h
  face = Bi::Sprite.new tex
  face.texture = tex
  face.set_position Bi.w/2,Bi.h/2
  face.anchor = :center
  root.add face

  f = Fiber.new do
    360.times do
      face.angle += 1
      Fiber.sleep 0.01
    end
    true
  end

  face.on_update{|node,delta|
    if f
      if f.resume
        f = nil
      end
    end
  }

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture_image 0, img
  Bi::add_layer layer
end

create_world
Bi::debug = true
Bi::start_run_loop
