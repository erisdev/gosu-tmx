module TMX
  class TileSet < Array
    attr_reader :properties
    attr_reader :first_index
    
    def initialize window, file_name, properties
      @window     = window
      @properties = properties.dup
      
      @first_index = @properties.delete :firstgid
      
      super Gosu::Image.load_tiles @window, file_name,
        *properties.values_at(:tilewidth, :tileheight), true
    end
  end
end
