module TMX
  class Layer < Array
    DEFAULT_OPTIONS = {
      :encoding    => nil,
      :compression => nil,
    }
    
    attr_reader :width, :height
    
    def initialize width, height, data, options = {}
      options = DEFAULT_OPTIONS.merge options
      
      super Coder.decode(data, options[:compression], options[:encoding])
      @width  = width
      @height = height
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
