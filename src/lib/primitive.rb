
class Line < Bi::Node
  attr_reader :line
  def initialize(x,y,x2,y2)
    super

    self.angle = Math.atan2(y2-y, x2-x) * 180 / Math::PI
    self.set_size Math.sqrt( (x2-x)**2 + (y2-y)**2 ), 1

    self.set_position x,y

    @line = [x,y,x2,y2]
  end
end

class Block < Bi::Node
  attr_reader :sides, :corners
  def initialize(x,y,w,h)
    super
    self.set_size w,h
    self.set_position x,y

    l = x
    r = x + w-1
    b = y
    t = y + h-1

    @sides = [
      [l,t,l,b], # left
      [r,t,r,b], # right
      [l,t,r,t], # top
      [l,b,r,b], # bottom
    ]

    @corners = [
      [l,t],
      [l,b],
      [r,t],
      [r,b]
    ]
  end
end
