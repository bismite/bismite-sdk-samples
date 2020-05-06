require "lib/stats"

Bi.init 480,320, title:__FILE__

Bi::Archive.new("assets.dat",0x5).load do |assets|
  root = Bi::Node.new
  root.set_size Bi.w, Bi.h
  root.set_color 0x33,0,0,0xff

  keycode_table = Bi::KeyCode.constants.map{|c| [Bi::KeyCode.const_get(c),c] }.to_h
  scancode_table = Bi::ScanCode.constants.map{|c| [Bi::ScanCode.const_get(c),c] }.to_h
  keymod_table = Bi::KeyMod.constants.map{|c| [Bi::KeyMod.const_get(c),c] }.to_h

  texture = assets.texture "assets/gohufont.png"
  font = Bi::Font.new texture, assets.read("assets/gohufont-bold-14-0.0.dat")

  labels = 15.times.map{|i|
    label = Bi::Label.new font
    label.anchor = :south_east
    label.text = "Press any Key"
    label.set_position Bi.w - 10, 10 + i*20
    label.set_color 0xff, 0xff, 0xff, 0xff - i*10
    root.add label
    label
  }

  root.on_key_input{|node,scancode,keycode,mod,pressed|
    pressed = pressed ? "Press" : "Release"
    if mod == 0
      mod = keymod_table[mod]
    else
      mod = keymod_table.keys.map{|k| (k!=0 and mod&k==k) ? keymod_table[k] : nil }.compact.join(",")
    end
    new_text = "Mod:#{mod} #{pressed} ScanCode:#{scancode_table[scancode]} KeyCode:#{keycode_table[keycode]}"

    texts = labels.map{|l| l.text }
    texts.pop
    texts.unshift new_text

    labels.each.with_index{|l,i| l.text = texts[i] }
  }

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture 0, texture
  Bi::add_layer layer

  stats assets
end

Bi::start_run_loop
