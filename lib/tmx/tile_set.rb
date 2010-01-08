module TMX
  class TileSet
    attr_reader :properties
    attr_reader :tiles
    attr_reader :first_id,   :last_id
    attr_reader :tile_width, :tile_height
    
    def initialize map, file_name_or_images, properties
      @map        = WeakRef.new map
      @properties = properties.dup
      
      @tile_width  = @properties.delete :tilewidth
      @tile_height = @properties.delete :tileheight
      
      @tiles = case file_name_or_images
        when String then file_name_or_images.dup
        when Array  then Gosu::Image.load_tiles(@map.window, file_name, @tile_width, @tile_height, true).freeze
        when nil    then []
        else raise ArgumentError, "must supply a file name or an array of images"
        end
      
      @first_id = @properties.delete :firstgid
      @last_id  = @first_id + @tiles.count - 1
    end
    
    def map; @map.__getobj__ end
    
    def [] tile_id
      raise IndexError unless range.include? tile_id
      @tiles[tile_id - @first_id]
    end
    
    def []= tile_id, image
      raise IndexError unless range.include? tile_id
      @tiles[tile_id - @first_id] = image
    end
    
    def range; @first_id..@last_id end
    
  end
end
