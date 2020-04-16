require "lib/stats"

class Particle < Bi::Sprite
  attr_accessor :life, :life_max
  def initialize(tex,x,y)
    super tex
    self.set_position x,y
    self.anchor = :center
    self.set_color rand(0xFF),rand(0xFF),rand(0xFF),0xff
    @life = @life_max = 20 + rand(20)
  end
  def life=(life)
    if life < 0
      self.remove_from_parent
    else
      @life = life
      self.set_alpha(0xff*@life/@life_max)
    end
  end
end

def create_world
  Bi::init 480,320,title:$0

  img = Bi::TextureImage.new "assets/ball.png", false
  tex = Bi::Texture.new img,0,0,img.w,img.h

  root = Bi::Node.new
  root.on_move_cursor {|n,x,y|
    particle = Particle.new tex, x, y
    particle.on_update {|n,delta|
      n.life -= 1
    }
    root.add particle
  }

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture_image 0, img
  Bi::add_layer layer
end

create_world
stats $0
Bi::start_run_loop
