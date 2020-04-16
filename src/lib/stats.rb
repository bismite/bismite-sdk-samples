
def stats(name)
  root = Bi::Node.new
  img = Bi::TextureImage.new "assets/gohufont.png", false
  font = Bi::Font::read img, "assets/gohufont-11-0.0.dat"

  title = Bi::Label.new font
  title.anchor = :north_east
  title.set_color 0,0,0,128
  title.set_text name
  title.set_position( Bi.w, Bi.h )
  root.add title

  label = Bi::Label.new font
  label.anchor = :north_west
  label.set_color 0,0,0,128
  label.set_text "FPS:"
  label.add_timer(1000,-1){|n,now,timer| n.set_text "FPS:#{Bi::fps.to_s}" }
  label.set_position( 0, Bi.h )
  root.add label

  info = []
  info << "GL:         #{Bi::Version.gl_version}"
  info << "GL Vendor:  #{Bi::Version.gl_vendor}"
  info << "GL Renderer:#{Bi::Version.gl_renderer}"
  info << "GL Shader:  #{Bi::Version.gl_shading_language_version}"
  info << "GLEW:       #{Bi::Version.glew_version}"
  info << "OS:         #{OS.sysname}(#{OS.machine})"
  info << "mruby:      #{MRUBY_DESCRIPTION}"
  info << "bicore:     #{Bi::Version.bicore}"
  info << "mruby-bicore: #{Bi::Version.mruby_bicore}"
  info << "biext:      #{Bi::Version.biext}"
  info << "mruby-biext:#{Bi::Version.mruby_biext}"
  info << "clang:      #{Bi::Version.clang}"
  info << "gnuc:       #{Bi::Version.gnuc}"
  info << "emscripten: #{Bi::Version.emscripten}"
  info << "SDL linked: #{Bi::Version.sdl}"
  info << "  compiled: #{Bi::Version.sdl_compiled}"

  info.each.with_index{|str,y|
    label = Bi::Label.new font
    label.set_text str
    label.anchor = :north_west
    label.set_position( 0, Bi.h - 11 - y*11 )
    label.set_color 0,0,0,128
    root.add label
  }

  # layer
  layer = Bi::Layer.new
  layer.root = root
  layer.set_texture_image 0, img
  Bi::add_layer layer
end
