class ActionSample < Bi::Node

  def initialize(w,h,img)
    super
    self.set_position 0,0
    self.set_size w,h

    face = Bi::Sprite.new Bi::Texture.new(img,0,0,img.w,img.h)
    face.anchor = :center
    face.set_position w/2, h/2
    self.add face

    face.on_click{|n,x,y,button,pressed|
      if pressed
        if n.actions and not n.actions.empty?
          n.remove_all_actions
        else
          n.set_position w/2, h/2
          add_action_to n
        end
      end
    }
  end

  def add_action_to(node)
    rot = Bi::Action::RotateBy.new(500, 90, proc{|node,action| p [:rotate, node, action]})
    move1 = Bi::Action::MoveTo.new(500, 0, 0, proc{|node,action| p [:move1, node, action]})
    move2 = Bi::Action::MoveTo.new(500, 200, 200, proc{|node,action| p [:move2, node, action]})
    seq = Bi::Action::Sequence.new( [rot,move1,move2], proc{|node,action| p [:sequence, node, action] })
    rep = Bi::Action::Repeat.new( seq, proc{|node,action| p [:repeat, node, action] })
    node.add_action rep
  end
end

Bi.init 480,320,title:"Action"
img = Bi::TextureImage.new "assets/face01.png", false
layer = Bi::Layer.new
layer.root = ActionSample.new 480, 320, img
layer.set_texture_image 0, img
Bi::add_layer layer

Bi::start_run_loop
