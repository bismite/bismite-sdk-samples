require "lib/stats"
require "lib/assets.rb"
require "lib/primitive.rb"

class LineIntersection < Bi::Node

  def initialize
    super

    self.set_size Bi.w, Bi.h

    @sky = Bi::Sprite.new Assets.texture "assets/sky.png"
    @sky.scale_x = Bi.w / @sky.w
    @sky.scale_y = Bi.h / @sky.h
    self.add @sky

    @line = Bi::Node.new
    @line.set_color 0xff,0xff,0xff,0xff
    @line.set_size 32,32
    @line.anchor = :west
    @line.scale_y = 1.0 / @line.h
    @line.x = Bi.w/2
    @line.y = Bi.h/2
    self.add @line

    @ball = Bi::Sprite.new Assets.texture "assets/ball.png"
    @ball.anchor = :center
    @ball.set_color 0,0xff,0,0xff
    self.add @ball

    @lines = []
    add_line 1000

    self.on_key_input do |node,scancode,keycode,mod,pressed|
      next if pressed
      case keycode
      when Bi::KeyCode::Z
        add_line 200
      when Bi::KeyCode::X
        remove_lines
      end
      Bi.title = "#{@lines.size}"
    end

    @sight_angle = 0
    self.on_update{|node,delta|
      @sight_angle += 1
      angle = @sight_angle * 0.01
      distance = Bi.h
      x = Bi.w/2 + distance * Math::cos(angle)
      y = Bi.h/2 + distance * Math::sin(angle)
      point(x,y)
    }

    # self.on_move_cursor{|node,x,y| point x,y }

  end

  def remove_lines
    @lines.each{|b| b.remove_from_parent }
    @lines = []
  end

  def add_line(n)
    n.times do
      x,y = *random_position(100,400)
      b = ::Line.new x, y, x+rand(-64..64), y+rand(-64..64)
      b.set_color 0xff,0xff,0xff,0xff
      self.add b
      @lines << b
    end
  end

  def point(x,y)
    lx = x - @line.x
    ly = y - @line.y
    @line.angle = Math.atan2(ly,lx) * 180 / Math::PI
    @line.scale_x = Math.sqrt( lx**2 + ly**2 ) / @line.w

    sx = @line.x
    sy = @line.y

    @ball.visible = false

    intersection = nil
    collide_block = nil

    @lines.each{|line|
      line.set_color 0xff,0xff,0xff,0xff
      if Bi::Line::intersection( @line.x, @line.y, x, y, *(line.line) )
        line.set_color 0xff,0,0,128
      end
    }
  end

  def random_position(near,far)
    angle = rand() * Math::PI*2
    distance = rand(near..far)
    x = (Bi.w/2 + distance * Math::cos(angle)).to_i
    y = (Bi.h/2 + distance * Math::sin(angle)).to_i
    return x,y
  end

end

Bi.init 480,320, title:$0
Assets.load_archive("assets.dat") do
  layer = Bi::Layer.new
  layer.root = LineIntersection.new
  Assets.texture_images.each.with_index{|image,i|
    layer.set_texture_image i, image
  }
  Bi::add_layer layer
  stats $0
end

Bi::start_run_loop