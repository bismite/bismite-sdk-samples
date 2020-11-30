require "lib/stats"

if Bi::Version.emscripten
SHADER_HEADER=<<EOS
#version 100
precision highp float;
EOS
else
SHADER_HEADER=<<EOS
#version 120
EOS
end

VERTEX_SHADER=<<EOS
#{SHADER_HEADER}
uniform mat4 projection;
uniform mat4 view;
attribute vec2 vertex;
attribute vec4 texture_uv;
attribute vec4 transform_a;
attribute vec4 transform_b;
attribute vec4 transform_c;
attribute vec4 transform_d;
attribute float vertex_index;
attribute float texture_z;
attribute vec4 mod_color;
varying vec3 uv;
varying vec4 color;
void main()
{
  gl_Position = projection * view * mat4(transform_a,transform_b,transform_c,transform_d) * vec4(vertex,0.0,1.0);

  // vertex = [ left-top, left-bottom, right-top, right-bottom ]
  // texture_uv = [ x:left, y:top, z:right, w:bottom ]
  int vertexid = int(vertex_index);
  if( vertexid == 0 ){
    uv = vec3(texture_uv.x,texture_uv.y,texture_z); // left-top
  }else if( vertexid == 1 ){
    uv = vec3(texture_uv.x,texture_uv.w,texture_z); // left-bottom
  }else if( vertexid == 2 ){
    uv = vec3(texture_uv.z,texture_uv.y,texture_z); // right-top
  }else if( vertexid == 3 ){
    uv = vec3(texture_uv.z,texture_uv.w,texture_z); // right-bottom
  }

  //
  color = mod_color;
}
EOS

FRAGMENT_SHADER_HEADER=<<EOS
#{SHADER_HEADER}
varying vec3 uv;
varying vec4 color;
uniform sampler2D sampler[8];
uniform float time;
uniform vec2 resolution;
uniform vec4 optional_attributes;

vec4 getTextureColor(int samplerID,vec2 xy) {
  // WebGL not supported dynamic indexing for sampler...
  if(samplerID==0){ return texture2D(sampler[0], xy); }
  if(samplerID==1){ return texture2D(sampler[1], xy); }
  if(samplerID==2){ return texture2D(sampler[2], xy); }
  if(samplerID==3){ return texture2D(sampler[3], xy); }
  if(samplerID==4){ return texture2D(sampler[4], xy); }
  if(samplerID==5){ return texture2D(sampler[5], xy); }
  if(samplerID==6){ return texture2D(sampler[6], xy); }
  if(samplerID==7){ return texture2D(sampler[7], xy); }
  return vec4(0);
}
EOS

FRAGMENT_SHADER=<<EOS
#{FRAGMENT_SHADER_HEADER}
void main()
{
  int samplerID = int(uv.z);
  if( 0 <= samplerID && samplerID <= 7 ) {
    // shake
    float offset = cos(gl_FragCoord.y * 0.1 + time * 10.0) * 0.1;
    gl_FragColor = getTextureColor(samplerID, vec2(uv.x+offset, uv.y)) * color;
  }else{
    gl_FragColor = color;
  }
}
EOS

POSTPROCESS_FRAGMENT_SHADER=<<EOS
#{FRAGMENT_SHADER_HEADER}
void main()
{
  int samplerID = int(uv.z);
  if( 0 <= samplerID && samplerID <= 7 ) {
    float beat = clamp(abs(sin(time*5.0)),0.8,1.0);
    float d = distance( gl_FragCoord.xy/resolution, vec2(0.5) );
    vec4 c = getTextureColor(samplerID, uv.xy) * color;
    // heart beat
    float red = clamp(c.r + d*beat, 0.0, 1.0);
    gl_FragColor = vec4(red,c.g,c.b,1.0);
  }else{
    gl_FragColor = color;
  }
}
EOS

Bi.init 480,320,title:__FILE__,hidpi:true

Bi::Archive.new("assets.dat",0x5,true).load do |assets|
  stats assets

  # layer
  layer = Bi::Layer.new
  layer.root = Bi::Node.new
  layer.root.set_color 0x33,0,0,0xff
  layer.root.set_size Bi.w,Bi.h
  Bi::add_layer layer

  layer.shader = Bi::Shader.new Bi.w,Bi.h,VERTEX_SHADER,FRAGMENT_SHADER
  Bi::shader = Bi::Shader.new Bi.w,Bi.h,VERTEX_SHADER,POSTPROCESS_FRAGMENT_SHADER

  layer.root.on_move_cursor {|n,x,y|
    layer.set_optional_shader_attributes 0, x
    layer.set_optional_shader_attributes 1, y

    Bi::set_optional_shader_attributes 0,x
    Bi::set_optional_shader_attributes 1,y
  }

  # bg
  sky = assets.texture("assets/sky.png").to_sprite
  layer.root.add sky

  # front texture
  face = assets.texture("assets/face01.png").to_sprite
  face.set_position Bi.w/2,Bi.h/2
  face.anchor = :center
  layer.root.add face

  layer.set_texture 0, sky.texture_mapping.texture
  layer.set_texture 1, face.texture_mapping.texture
end

Bi::start_run_loop
