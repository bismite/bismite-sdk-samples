class Assets
  DECRYPT_SECRET=0x5

  def self.load_archive(name,&callback)
    @texture_images = {}
    @archive = Bi::Archive.new(name,DECRYPT_SECRET)

    if File.exists? name
      @archive.load{|archive|
        @archive.filenames.select{|f|
          f.end_with? ".png"
        }.each{|f|
          puts f
          @texture_images[f] = @archive.texture_image f, false
        }
        callback.call(@archive)
      }
    else
      callback.call(@archive)
    end
  end

  def self.texture_images
    @texture_images.values
  end

  def self.texture(name)
    img = self.texture_image name
    Bi::Texture.new img, 0,0,img.w,img.h
  end

  def self.texture_image(name)
    img = @texture_images[name]
    unless img
      img = Bi::TextureImage.new name, false
      @texture_images[name] = img
    end
    img
  end

  def self.read(name)
    f = @archive.read(name)
    p [f,name]
    f = File.open(name).read unless f
    f
  end

  def self.music(name)
    @archive.music name
  end
  def self.sound(name)
    @archive.sound name
  end
end
