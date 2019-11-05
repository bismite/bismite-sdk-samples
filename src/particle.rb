
class Particle < Bi::Sprite
  attr_accessor :life, :life_max, :xx, :yy, :vx, :vy
  def initialize(tex,x,y)
    super tex
    self.set_position x,y
    self.anchor = :center
    self.set_color rand(0xFF),rand(0xFF),rand(0xFF),0xff
    @life = @life_max = 200 + rand(200)
    @vx = (rand(nil)-0.5) * 3
    @vy = (rand(nil)-0.5) * 3
    @xx = x.to_f
    @yy = y.to_f
  end
  def life=(life)
    if life < 0
      self.parent.remove self
    else
      @life = life
      self.set_alpha(0xff*@life/@life_max)
    end
  end
  def my_update(n,delta)
    n.life -= 1
    n.xx += n.vx
    n.yy += n.vy
    n.set_position(n.xx, n.yy)
  end
end

class ParticleExample < Bi::Node
  def initialize(w,h,img)
    super()
    self.set_color 32,0,0,0xff
    self.set_position 0,0
    self.set_size w,h
    @img = img
    @tex = Bi::Texture.new @img,0,0,@img.w,@img.h
    self.on_click{|node,x,y,button,pressed|
      self.add_particle(x,y,rand(20..100)) if pressed
    }
  end
  def add_particle(x,y,num)
    num.times{
      particle = Particle.new @tex, x, y
      particle.on_update :my_update
      self.add particle
    }
  end
end

def create_world
  Bi::init 480,320, title:"Click to add Particles"

  img = Bi::TextureImage.new "assets/ball.png", false
  root = ParticleExample.new(480,320,img)

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture_image 0, img
  layer.blend_src = Bi::Layer::GL_SRC_ALPHA
  layer.blend_dst = Bi::Layer::GL_ONE
  Bi::add_layer layer
end

def add_fps_layer
  img = Bi::TextureImage.new "assets/gohufont.png", true
  font = Bi::Font.new img, "assets/gohufont-bold-14-0.0.dat"
  label = Bi::Label.new font
  label.anchor = :north_west
  label.set_color 0,0,0,128
  label.add_timer(1000,-1){|n,now,timer| n.set_text "FPS:#{Bi::fps.to_s}" }
  label.set_position( 0, Bi.h )
  # layer
  layer = Bi::Layer.new
  layer.root = label
  layer.set_texture_image 0, img
  Bi::add_layer layer
end

create_world
add_fps_layer
GC.start
Bi::debug = true
Bi::start_run_loop
