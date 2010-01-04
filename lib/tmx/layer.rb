module TMX
  class Layer < Array
    attr_reader :properties
    attr_reader :width, :height
    
    def initialize data, properties
      super data.bytes.to_a
      
      @properties = properties.dup
      
      @width  = @properties.delete(:width)  or raise ArgumentError, "layer width is required"
      @height = @properties.delete(:height) or raise ArgumentError, "layer height is required"
    end
    
    def [] x, y
      super offset(x, y)
    end
    
    def []= x, y, id
      super offset(x, y), id
    end
    
    private
    
    def offset x, y
      x + y * @width
    end
    
  end # Layer
end
