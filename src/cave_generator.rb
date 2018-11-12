
class Fiber
  def self.sleep(sec)
    t = Time.now
    self.yield while Time.now - t < sec
  end
end

class CaveGeneratorExample < Bi::Node
  WALL=[0x18,0x01,0x0d,0xFF]
  FLOOR=[0x64,0x4d,0x37,0xFF]

  def initialize(w,h)
    super
    self.set_bound 0,0, w,h

    t = self.add_timer(1000,-1){|n,now,timer| Bi::title = "FPS:#{Bi::fps}" }
    p [:fps_timer,t]

    grid_width = 48
    grid_height = 48
    birth = [5,6,7,8]
    death = [0,1,2,3]

    srand(Time.now.to_i)

    @step = rand(6..14)
    p [:total_step, @step]

    @grid = (grid_width*grid_height).times.map{ rand(100)<50?0:1 }
    grid_width.times{|x| @grid[0+x] = @grid[(grid_height-1)*grid_width+x] = 0 }
    grid_height.times{|y| @grid[grid_width*y+0] = @grid[grid_width*y+grid_width-1] = 0 }

    @nodes = grid_width.times.map{|x|
      grid_height.times.map{|y|
        n = Bi::Node.new
        n.set_bound(x*4,y*4,4,4)
        add_child n
        n
      }
    }.flatten

    update_grids

    f = Fiber.new do
      @step.times do |i|
        p [Time.now, :step, i]
        @grid = CellularAutomaton.step(@grid,grid_width,birth,death,true)
        grid_width.times{|x| @grid[0+x] = @grid[(grid_height-1)*grid_width+x] = 0 }
        grid_height.times{|y| @grid[grid_width*y+0] = @grid[grid_width*y+grid_width-1] = 0 }
        self.update_grids
        Fiber.sleep 0.8
      end
      true
    end

    self.on_update{|node,delta| f = nil if f and f.resume }

  end

  def update_grids
    @grid.each.with_index{|g,i|
      if g == 0
        @nodes[i].set_color(*WALL)
      else
        @nodes[i].set_color(*FLOOR)
      end
    }
  end

end

Bi.init 192,192, title:"cave generator"
layer = Bi::Layer.new
layer.root = CaveGeneratorExample.new(192,192)
Bi::add_layer layer
Bi.start_run_loop
