module TMX
  class Layer
    attr_reader :properties
    attr_reader :width, :height
    
    def initialize map, data, properties
      @map        = WeakRef.new map
      @properties = properties.dup
      
      @width  = @properties.delete(:width)     or raise ArgumentError, "layer width is required"
      @height = @properties.delete(:height)    or raise ArgumentError, "layer height is required"
      
      @tile_ids = case data
        when String then data.unpack('V*')
        when Array  then data.dup
        when nil    then Array.new @width * @height, 0
        else raise ArgumentError, "data must be a binary string or an array of integers"
        end
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
    
    def each_tile_id &block
      y_range.each do |y|
        x_range.each do |x|
          yield x, y, @tile_ids[offset(x, y)]
        end
      end
    end # each_tile_id
    
    def x_range; 0...@width  end
    def y_range; 0...@height end
    
    private
    
    def offset x, y
      x + y * @width
    end
    
  end # Layer
end
