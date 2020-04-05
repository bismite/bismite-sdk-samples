
def create_world
  Bi.init 480,320,title:"Texture"

  root = Bi::Node.new
  root.set_size Bi.w, Bi.h
  root.set_color 0x33,0,0,0xff

  keycode_table = Bi::KeyCode.constants.map{|c| [Bi::KeyCode.const_get(c),c] }.to_h
  scancode_table = Bi::ScanCode.constants.map{|c| [Bi::ScanCode.const_get(c),c] }.to_h
  keymod_table = Bi::KeyMod.constants.map{|c| [Bi::KeyMod.const_get(c),c] }.to_h

  img = Bi::TextureImage.new "assets/gohufont.png", true
  font = Bi::Font.read img, "assets/gohufont-bold-14-0.0.dat"
  label = Bi::Label.new font
  label.anchor = :north_west
  label.set_text "Press any Key"
  label.set_position 10, Bi.h/2
  root.add label

  root.on_key_input{|node,scancode,keycode,mod,pressed|
    p [pressed, scancode_table[scancode], keycode_table[keycode], keymod_table[mod] ]
    label.set_text "#{[pressed, scancode_table[scancode], keycode_table[keycode], keymod_table[mod] ]}"
  }

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture_image 0, img
  Bi::add_layer layer
end

create_world
Bi::start_run_loop
