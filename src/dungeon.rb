
class DungeonLayer < Bi::Layer
  include Singleton
end

class Dungeon < Bi::Node

  class Grid
    attr_accessor :type, :variation
    def initialize(type,variation)
      @type = type
      @variation = variation
    end
  end

  def make_dungeon
    @grid_width = 64
    @grid_height = 64
    birth = [5,6,7,8]
    death = [0,1,2,3]

    srand(Time.now.to_i)

    grid = (@grid_width*@grid_height).times.map{ rand(100)<50?0:1 }
    @grid_width.times{|x| grid[0+x] = grid[(@grid_height-1)*@grid_width+x] = 0 }
    @grid_height.times{|y| grid[@grid_width*y+0] = grid[@grid_width*y+@grid_width-1] = 0 }

    rand(8..12).times do
      grid = CellularAutomaton.step(grid,@grid_width,birth,death,true)
      @grid_width.times{|x| grid[0+x] = grid[(@grid_height-1)*@grid_width+x] = 0 }
      @grid_height.times{|y| grid[@grid_width*y+0] = grid[@grid_width*y+@grid_width-1] = 0 }
    end

    @grid = grid.map{|g|
      Grid.new( g==0 ? :wall : :floor, rand(3) )
    }
  end

  def initialize(w,h,wall,floor)
    super
    self.set_position 0,0
    self.set_size w,h
    t = self.add_timer(1000,-1){|n,now,timer| Bi::title = "FPS:#{Bi::fps}" }

    @tiles = {
      wall: 3.times.map{|i| Bi::Texture.new(wall,i*32,0,32,32) },
      floor: 3.times.map{|i| Bi::Texture.new(floor,i*32,0,32,32) }
    }

    make_dungeon

    @nodes = @grid_width.times.map{|x|
      @grid_height.times.map{|y|
        g = @grid[y*@grid_width+x]
        n = Bi::Sprite.new @tiles[g.type][g.variation]
        n.set_position x*32, y*32
        self.add n
        n
      }
    }.flatten

    self.on_key_input{|n,scancode,keycode,mod,pressed|
      next unless pressed
      case keycode
      when Bi::KeyCode::LEFT
        DungeonLayer.instance.camera_x -= 32
      when Bi::KeyCode::RIGHT
        DungeonLayer.instance.camera_x += 32
      when Bi::KeyCode::UP
        DungeonLayer.instance.camera_y += 32
      when Bi::KeyCode::DOWN
        DungeonLayer.instance.camera_y -= 32
      end
    }

  end

end

def add_fps_layer
  img = Bi::TextureImage.new "assets/gohufont.png", true
  font = Bi::Font.new img, "assets/gohufont-bold-14-0.0.dat"
  label = Bi::Label.new font
  label.anchor = :north_west
  label.set_color 0,0,0,128
  label.add_timer(1000,-1){|n,delta| n.set_text "FPS:#{Bi::fps.to_s}"}
  label.set_position( 0, Bi.h )
  # layer
  layer = Bi::Layer.new
  layer.root = label
  layer.set_texture_image 0, img
  Bi::add_layer layer
end

Bi.init 1024,704, title:"Dungeon Example"
Bi.debug = true

layer = DungeonLayer.instance
wall = Bi::TextureImage.new "assets/wall.png", false
floor = Bi::TextureImage.new "assets/floor.png", false
layer.root = Dungeon.new(1024,768,wall,floor)
layer.set_texture_image 0, wall
layer.set_texture_image 1, floor
Bi::add_layer layer

add_fps_layer

Bi.start_run_loop
