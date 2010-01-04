module TMX
  class Map
    attr_reader :properties
    attr_reader :width,      :height
    attr_reader :tile_width, :tile_height
    
    DEFAULT_OPTIONS = {
      :scale_units => true,
      
      :on_object_group => nil,
      :on_object       => nil,
    }
    
    def initialize window, file_name, options = {}
      options = DEFAULT_OPTIONS.merge options
      
      mapdef = File.open(file_name) do |io|
        doc = Nokogiri::XML(io) { |conf| conf.noent.noblanks }
        
        doc.root
      end
      
      raise "Only version 1.0 maps are currently supported" unless mapdef['version']     == '1.0'
      raise "Only orthogonal maps are currently supported"  unless mapdef['orientation'] == 'orthogonal'
      
      @tile_width  = mapdef['tilewidth'].to_i
      @tile_height = mapdef['tileheight'].to_i
      
      @width  = mapdef['width'].to_i
      @height = mapdef['height'].to_i
      
      @scale_units = options[:scale_units] \
        ? 1.0 / [@tile_height, @tile_width].min \
        : false
      
      mapdef.children.each do |e|
        case e.name
        when 'properties'  then @properties = e.parse_properties
        when 'tileset'     then create_tile_set e
        when 'layer'       then create_layer e
        when 'objectgroup' then create_object_group e
        end
      end
      
      # callbacks for custom object creation
      @on_object_group = options[:on_object_group]
      @on_object       = options[:on_object]
    end
    
    protected
    
    def create_tile_set tsdef
    end
    
    def create_layer layerdef
    end
    
    def create_object_group xml
      properties = xml.parse_properties.merge! xml.parse_attributes
      name       = properties.delete(:name)
      
      group = on_object_group name, properties
      
      xml.children.each do |child|
        create_object child, group
      end
      
      group
    end
    
    def create_object xml, group
      properties = xml.parse_properties.merge! xml.parse_attributes
      name       = properties.delete(:name)
      
      [:x, :y, :width, :height].each do |key|
        properties[key] = properties[key] * @scale_units
      end if @scale_units
      
      on_object name, group, properties
    end
    
    def on_object_group name, properties
      if @on_object_group
        @on_object_group.call name, properties
      else
        $stderr.puts "OBJECT GROUP #{name} #{properties.inspect}"
        name
      end
    end # on_object_group
    
    def on_object name, group, properties
      if @on_object
        @on_object.call group, name, properties
      else
        $stderr.puts "OBJECT #{name} of #{group} #{properties.inspect}"
      end
    end # on_object
    
  end # Map
end
