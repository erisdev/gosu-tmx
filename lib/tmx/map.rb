require 'rexml/document'

module TMX
  class Map
    attr_reader :width,      :height
    attr_reader :tile_width, :tile_height
    
    def initialize window, file_name, options = {}
      doc = File.open(file_name) { |io| REXML::Document.new io }
      
      attrs = doc.root.attributes
      
      raise "Only version 1.0 maps are currently supported" unless attrs['version']     == '1.0'
      raise "Only orthogonal maps are currently supported"  unless arrts['orientation'] == 'orthogonal'
      
      @tile_width  = attrs['tilewidth'].to_i
      @tile_height = attrs['tileheight'].to_i
      
      @width  = attrs['width'].to_i
      @height = attrs['height'].to_i
      
      # callbacks for custom object creation
      @on_object_group = options[:on_object_group]
      @on_object       = options[:on_object]
    end
    
    protected
    
    def on_object_group name, width, height, properties
      @on_object_group.call name, width, height, properties if @on_object_group
    end
    
    def on_object group, name, type, x, y, width, height, properties
      @on_object.call group, name, type, x, y, width, height, properties if @on_object
    end
    
  end # Map
end
