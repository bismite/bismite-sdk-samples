
def create_world
  Bi::init 480,320, title:"Label"

  root = Bi::Node.new

  img = Bi::TextureImage.new "assets/gohufont.png", false
  font = Bi::Font.new img, "assets/gohufont-bold-14-0.0.dat"

  # label-1
  label = Bi::Label.new font
  label.set_text "FPS:"
  label.anchor = :north_west
  label.set_position( 0, Bi.h )
  label.add_timer(1000,-1){|n,delta| n.set_text "FPS:#{Bi::fps.to_s}" }
  root.add label

  # label-2
  label = Bi::Label.new font
  label.set_position Bi.w/2, Bi.h/2
  label.set_color 0xff,0xff,0xff,0x33
  label.anchor = :center
  label.scale_x = label.scale_y = 3.0
  label.add_timer(500,-1){|n,now,timer|
    label.set_text ["ABCDEF","(@o@)","('_`)","(^_^)"].sample
  }
  root.add label

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture_image 0, img
  Bi::add_layer layer
end

create_world
Bi::start_run_loop
