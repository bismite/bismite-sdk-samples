require "lib/stats"

class Menu < Bi::Node
  attr_accessor :selected_background_color
  attr_accessor :unselected_background_color
  def initialize(font)
    super
    @font = font
    @items = []
    @callbacks = []
    self.on_move_cursor {|n,x,y| self.check_menu_select(x,y) }
    self.on_click {|n,x,y,button,press| self.check_menu_click(x,y,button,press) }
    @selected_background_color = [0xff,0xff,0xff,128]
    @unselected_background_color = [0,0,0,0]
    @vertical_margin = 20
  end
  def check_menu_select(x,y)
    swallow = false
    @items.each{|item|
      if item.include?(x,y)
        item.set_background_color(*@selected_background_color)
        swallow = true
      else
        item.set_background_color(*@unselected_background_color)
      end
    }
    swallow
  end
  def check_menu_click(x,y,button,press)
    swallow = false
    @items.each_with_index{|item,i|
      if item.include?(x,y)
        item.set_background_color(*@selected_background_color)
        @callbacks[i].call item
        swallow = true
        break
      end
    }
    swallow
  end
  def add_item(title,&block)
    label = Bi::Label.new @font
    label.set_text title
    label.scale_x = label.scale_y = 2.0
    label.anchor = :center
    self.add label
    label.set_position 0, -@items.size*(@font.size+@vertical_margin)
    @items << label
    @callbacks << block
  end
end

Bi::init 480,320, title:__FILE__
Bi::Archive.new("assets.dat",0x5).load do |assets|
  font_texture = assets.texture "assets/mixed.png"
  layout = assets.read("assets/large-bold.dat")
  font = Bi::Font.new font_texture, layout

  root = Bi::Node.new

  face_texture = assets.texture "assets/face01.png"
  face = face_texture.to_sprite
  face.anchor = :center
  face.set_position 240,160
  root.add face

  menu = Menu.new(font)
  menu.add_item("RED"){|item| face.set_color 0xff,0,0,0xff }
  menu.add_item("GREEN"){|item| face.set_color 0,0xff,0,0xff }
  menu.add_item("BLUE"){|item| face.set_color 0,0,0xff,0xff }
  menu.add_item("WHITE"){|item| face.set_color 0xff,0xff,0xff,0xff }
  menu.set_position 240,160
  root.add menu

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture 0, font_texture
  layer.set_texture 1, face_texture
  Bi::add_layer layer

  stats assets
end

Bi::start_run_loop
