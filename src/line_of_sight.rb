require "lib/assets.rb"
require "lib/primitive.rb"
require "lib/stats.rb"

class LineOfSight < Bi::Node

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

    reset_blocks

    self.on_key_input do |node,key,code,mod,pressed|
      next if pressed
      reset_blocks
    end

    # self.on_move_cursor{|node,x,y| point(x,y) }
    @sight_angle = 0
    self.on_update{|node,delta|
      @sight_angle += 1
      angle = @sight_angle * 0.01
      distance = Bi.h
      x = Bi.w/2 + distance * Math::cos(angle)
      y = Bi.h/2 + distance * Math::sin(angle)
      point(x,y)
    }
  end

  def reset_blocks
    if @blocks
      @blocks.each{|b| b.remove_from_parent }
    end
    @blocks = 50.times.map do
      angle = rand() * Math::PI*2
      distance = rand(100..300)
      x = Bi.w/2 + distance * Math::cos(angle)
      y = Bi.h/2 + distance * Math::sin(angle)
      b = Block.new x,y,rand(32..64), rand(32..64)
      b.set_color 0xff,0xff,0xff,32
      self.add b
      b
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

    @blocks.each{|block|
      block.set_color 0xff,0xff,0xff,32

      nearest = Bi::Line::nearest_intersection @line.x, @line.y, x, y, block.sides+block.corners

      if nearest
        block.set_color 0xff,0xff,0,32
        if intersection
          if Bi::Line::compare_length(@line.x,@line.y, intersection[0], intersection[1], @line.x, @line.y, nearest[0], nearest[1] ) > 0
            intersection = nearest
            collide_block = block
          end
        elsif
          intersection = nearest
          collide_block = block
        end
      end
    }

    if intersection and collide_block
      collide_block.set_color 0xff,0,0,32
      @ball.set_position(*intersection)
      @ball.visible = true
    end

  end

end

Bi.init 480,320, title:$0
Assets.load_archive("assets.dat") do
  srand(Time.now.to_i)
  layer = Bi::Layer.new
  layer.root = LineOfSight.new
  Assets.texture_images.each.with_index{|image,i|
    layer.set_texture_image i, image
  }
  Bi::add_layer layer
  stats $0
end

Bi::start_run_loop
