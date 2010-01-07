module TMX
  class Layer
    attr_reader :properties
    attr_reader :width, :height
    
    def initialize map, data, properties
      @map        = WeakRef.new map
      @properties = properties.dup
      
      @width  = @properties.delete(:width)     or raise ArgumentError, "layer width is required"
      @height = @properties.delete(:height)    or raise ArgumentError, "layer height is required"
    end # initialize
    
    def map; @map.__getobj__ end
    
    def [] x, y
      raise IndexError unless x_range.include? x and y_range.include? y
      @tile_ids[offset(x, y)]
    end
    
    def []= x, y, id
      raise IndexError unless x_range.include? x and y_range.include? y
      @tile_ids[offset(x, y)] = id
    end
    
    def x_range; 0...@width  end
    def y_range; 0...@height end
    
    private
    
    def offset x, y
      x + y * @width
    end
    
  end # Layer
end
