require "lib/stats"

def create_world
  Bi::init 480,320, title:$0

  root = Bi::Node.new
  root.set_size Bi.w, Bi.h
  root.set_color 0x33,0,0,0xff

  img = Bi::TextureImage.new "assets/gohufont.png", false
  font = Bi::Font::read img, "assets/gohufont-bold-14-0.0.dat"

  label = Bi::Label.new font
  label.set_position Bi.w/2, Bi.h/2
  label.set_color 0xff,0xff,0xff,0x33
  label.anchor = :center
  label.scale_x = label.scale_y = 3.0
  label.add_timer(500,-1){|n,now,timer|
    label.set_text ["Label","ABCDEF","(@o@)","('_`)","(^_^)"].sample
  }
  root.add label

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture_image 0, img
  Bi::add_layer layer
end

create_world
stats $0
Bi::start_run_loop
